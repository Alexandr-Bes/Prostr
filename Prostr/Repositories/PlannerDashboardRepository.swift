//
//  PlannerDashboardRepository.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
protocol PlannerDashboardRepositoryProtocol {
    func fetchDashboard() async throws -> PlannerDashboard
    func fetchContentCards() async throws -> [PlannerContentCard]
    func fetchContentCard(id: String) async throws -> PlannerContentCard?
    func createContentCard(_ card: PlannerContentCard) async throws -> PlannerDashboard
    func addTodoItem(title: String, dueDate: Date) async throws -> PlannerDashboard
    func toggleTodoItem(id: String) async throws -> PlannerDashboard
    func updateContentCard(_ card: PlannerContentCard) async throws -> PlannerDashboard
    func deleteContentCard(id: String) async throws -> PlannerDashboard
    func dashboardUpdates() -> AsyncStream<PlannerDashboard>
}

final class PlannerDashboardRepository: PlannerDashboardRepositoryProtocol {
    private let service: any PlannerDashboardServiceProtocol
    private let contentCardStore: (any PlannerContentCardStoreProtocol)?
    private let calendar = Calendar(identifier: .gregorian)

    private var cachedDashboard: PlannerDashboard?
    private var updateContinuations: [UUID: AsyncStream<PlannerDashboard>.Continuation] = [:]

    init(
        service: any PlannerDashboardServiceProtocol,
        contentCardStore: (any PlannerContentCardStoreProtocol)? = nil
    ) {
        self.service = service
        self.contentCardStore = contentCardStore
    }

    func fetchDashboard() async throws -> PlannerDashboard {
        if let cachedDashboard {
            return cachedDashboard
        }

        let dashboard = try await loadDashboard(forceRefresh: cachedDashboard == nil)
        return dashboard
    }

    func fetchContentCards() async throws -> [PlannerContentCard] {
        let dashboard = try await fetchDashboard()
        return dashboard.cards
    }

    func fetchContentCard(id: String) async throws -> PlannerContentCard? {
        let dashboard = try await fetchDashboard()
        return dashboard.cards.first { $0.id == id }
    }

    func createContentCard(_ card: PlannerContentCard) async throws -> PlannerDashboard {
        let dashboard = try await loadDashboard()

        try await contentCardStore?.createPost(card)

        let updatedDashboard = dashboard.updating(cards: dashboard.cards + [card])
        publish(updatedDashboard)

        return updatedDashboard
    }

    func addTodoItem(title: String, dueDate: Date) async throws -> PlannerDashboard {
        let normalizedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedTitle.isEmpty else {
            return try await fetchDashboard()
        }

        let dashboard = try await loadDashboard()
        let todoItem = PlannerTodoItem(
            id: UUID().uuidString,
            title: normalizedTitle,
            state: PlannerTodoState.state(
                for: dueDate,
                referenceDate: .now,
                calendar: calendar
            ),
            dueDate: dueDate
        )

        let updatedDashboard = dashboard.updating(todoItems: dashboard.todoItems + [todoItem])
        publish(updatedDashboard)
        return updatedDashboard
    }

    func toggleTodoItem(id: String) async throws -> PlannerDashboard {
        let dashboard = try await loadDashboard()
        let updatedItems = dashboard.todoItems.map { item in
            guard item.id == id else {
                return item
            }

            return item.toggled(relativeTo: .now, calendar: calendar)
        }

        let updatedDashboard = dashboard.updating(todoItems: updatedItems)
        publish(updatedDashboard)
        return updatedDashboard
    }

    func updateContentCard(_ card: PlannerContentCard) async throws -> PlannerDashboard {
        let dashboard = try await loadDashboard()
        let updatedDashboard = dashboard.updating(contentCard: card)

        try await contentCardStore?.updatePost(card)
        publish(updatedDashboard)

        return updatedDashboard
    }

    func deleteContentCard(id: String) async throws -> PlannerDashboard {
        let dashboard = try await loadDashboard()
        let updatedDashboard = dashboard.updating(
            cards: dashboard.cards.filter { $0.id != id }
        )

        try await contentCardStore?.deletePost(id: id)
        publish(updatedDashboard)

        return updatedDashboard
    }

    func dashboardUpdates() -> AsyncStream<PlannerDashboard> {
        let continuationID = UUID()

        return AsyncStream { continuation in
            updateContinuations[continuationID] = continuation

            if let cachedDashboard {
                continuation.yield(cachedDashboard)
            }

            continuation.onTermination = { @Sendable [weak self] _ in
                guard let self else { return }

                Task { @MainActor in
                    self.updateContinuations.removeValue(forKey: continuationID)
                }
            }
        }
    }
}

private extension PlannerDashboardRepository {
    func loadDashboard(forceRefresh: Bool = false) async throws -> PlannerDashboard {
        if let cachedDashboard, !forceRefresh {
            return cachedDashboard
        }

        let dashboard = try await service.fetchDashboard()
        let mergedDashboard = try await mergeStoredPosts(into: dashboard)
        publish(mergedDashboard)
        return mergedDashboard
    }

    func publish(_ dashboard: PlannerDashboard) {
        cachedDashboard = dashboard
        updateContinuations.values.forEach { $0.yield(dashboard) }
    }

    func mergeStoredPosts(into dashboard: PlannerDashboard) async throws -> PlannerDashboard {
        guard let contentCardStore else {
            return dashboard
        }

        let storedCards = try await contentCardStore.fetchPosts()
        let seededCards: [PlannerContentCard]

        if storedCards.isEmpty {
            for remoteCard in dashboard.cards {
                try await contentCardStore.createPost(remoteCard)
            }

            seededCards = dashboard.cards
        } else {
            let storedCardIDs = Set(storedCards.map(\.id))
            let missingRemoteCards = dashboard.cards.filter { !storedCardIDs.contains($0.id) }

            for remoteCard in missingRemoteCards {
                try await contentCardStore.createPost(remoteCard)
            }

            seededCards = try await contentCardStore.fetchPosts()
        }

        let resolvedCards = mergeCardOrder(
            remoteCards: dashboard.cards,
            storedCards: seededCards
        )

        return PlannerDashboard(
            screenTitle: dashboard.screenTitle,
            visibleMonth: dashboard.visibleMonth,
            selectedDate: dashboard.selectedDate,
            cards: resolvedCards,
            todoItems: dashboard.todoItems,
            ideas: dashboard.ideas
        )
    }

    func mergeCardOrder(
        remoteCards: [PlannerContentCard],
        storedCards: [PlannerContentCard]
    ) -> [PlannerContentCard] {
        let storedCardsByID = Dictionary(uniqueKeysWithValues: storedCards.map { ($0.id, $0) })
        let remoteCardIDs = Set(remoteCards.map(\.id))

        let orderedRemoteCards = remoteCards.map { storedCardsByID[$0.id] ?? $0 }
        let localOnlyCards = storedCards
            .filter { !remoteCardIDs.contains($0.id) }
            .sorted(by: sortLocalCards(_:_:))

        return orderedRemoteCards + localOnlyCards
    }

    func sortLocalCards(_ lhs: PlannerContentCard, _ rhs: PlannerContentCard) -> Bool {
        if lhs.effectiveDisplayDate != rhs.effectiveDisplayDate {
            return lhs.effectiveDisplayDate < rhs.effectiveDisplayDate
        }

        if lhs.createdAt != rhs.createdAt {
            return lhs.createdAt < rhs.createdAt
        }

        return lhs.title.localizedCaseInsensitiveCompare(rhs.title) == .orderedAscending
    }
}
