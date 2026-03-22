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

    private(set) var items: [PlannerTodoItem] = []

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        self.plannerDashboardRepository = plannerDashboardRepository
    }

    init(previewDashboard: PlannerDashboard = PlannerDashboardMockData.dashboard) {
        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.items = previewDashboard.todoItems
        self.hasLoaded = true
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        do {
            items = try await plannerDashboardRepository.fetchDashboard().todoItems
            hasLoaded = true
        } catch {
            Log.error(error)
        }
    }
}
