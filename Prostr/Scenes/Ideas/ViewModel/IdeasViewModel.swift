//
//  IdeasViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class IdeasViewModel {
    private let plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    private var hasLoaded = false

    private(set) var ideas: [PlannerIdea] = []

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        self.plannerDashboardRepository = plannerDashboardRepository
    }

    init(previewDashboard: PlannerDashboard = PlannerDashboardMockData.dashboard) {
        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.ideas = previewDashboard.ideas
        self.hasLoaded = true
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        do {
            ideas = try await plannerDashboardRepository.fetchDashboard().ideas
            hasLoaded = true
        } catch {
            Log.error(error)
        }
    }
}
