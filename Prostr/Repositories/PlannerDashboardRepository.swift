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
    func addTodoItem(title: String, dueDate: Date) async throws -> PlannerDashboard
    func toggleTodoItem(id: String) async throws -> PlannerDashboard
    func dashboardUpdates() -> AsyncStream<PlannerDashboard>
}

final class PlannerDashboardRepository: PlannerDashboardRepositoryProtocol {
    private let service: any PlannerDashboardServiceProtocol
    private let calendar = Calendar(identifier: .gregorian)

    private var cachedDashboard: PlannerDashboard?
    private var updateContinuations: [UUID: AsyncStream<PlannerDashboard>.Continuation] = [:]

    init(service: any PlannerDashboardServiceProtocol) {
        self.service = service
    }

    func fetchDashboard() async throws -> PlannerDashboard {
        if let cachedDashboard {
            return cachedDashboard
        }

        let dashboard = try await service.fetchDashboard()
        publish(dashboard)
        return dashboard
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

    func dashboardUpdates() -> AsyncStream<PlannerDashboard> {
        let continuationID = UUID()

        return AsyncStream { continuation in
            updateContinuations[continuationID] = continuation

            if let cachedDashboard {
                continuation.yield(cachedDashboard)
            }

            continuation.onTermination = { @Sendable [weak self] _ in
                Task { @MainActor in
                    self?.updateContinuations.removeValue(forKey: continuationID)
                }
            }
        }
    }
}

private extension PlannerDashboardRepository {
    func loadDashboard() async throws -> PlannerDashboard {
        if let cachedDashboard {
            return cachedDashboard
        }

        let dashboard = try await service.fetchDashboard()
        publish(dashboard)
        return dashboard
    }

    func publish(_ dashboard: PlannerDashboard) {
        cachedDashboard = dashboard
        updateContinuations.values.forEach { $0.yield(dashboard) }
    }
}
