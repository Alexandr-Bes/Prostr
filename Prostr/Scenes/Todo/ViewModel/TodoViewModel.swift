//
//  TodoViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class TodoViewModel {
    private let plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    private var hasLoaded = false
    private var dashboardUpdatesTask: Task<Void, Never>?

    private(set) var items: [PlannerTodoItem] = []

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        self.plannerDashboardRepository = plannerDashboardRepository
        observeDashboardUpdates()
    }

    init(previewDashboard: PlannerDashboard) {
        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.items = sort(previewDashboard.todoItems)
        self.hasLoaded = true
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        do {
            items = sort(try await plannerDashboardRepository.fetchDashboard().todoItems)
            hasLoaded = true
        } catch {
            Log.error(error)
        }
    }

    func toggleTodoItem(id: String) async {
        do {
            let dashboard = try await plannerDashboardRepository.toggleTodoItem(id: id)
            items = sort(dashboard.todoItems)
        } catch {
            Log.error(error)
        }
    }
}

private extension TodoViewModel {
    func observeDashboardUpdates() {
        dashboardUpdatesTask = Task { [weak self] in
            guard let self else { return }

            let updates = self.plannerDashboardRepository.dashboardUpdates()

            for await dashboard in updates {
                self.receiveDashboardUpdate(dashboard)
            }
        }
    }

    func receiveDashboardUpdate(_ dashboard: PlannerDashboard) {
        items = sort(dashboard.todoItems)
        hasLoaded = true
    }

    func sort(_ items: [PlannerTodoItem]) -> [PlannerTodoItem] {
        items.sorted { left, right in
            if left.isCompleted != right.isCompleted {
                return !left.isCompleted
            }

            if left.dueDate != right.dueDate {
                return left.dueDate < right.dueDate
            }

            return left.title.localizedCaseInsensitiveCompare(right.title) == .orderedAscending
        }
    }
}
