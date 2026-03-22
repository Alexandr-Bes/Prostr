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
}

final class PlannerDashboardRepository: PlannerDashboardRepositoryProtocol {
    private let service: any PlannerDashboardServiceProtocol

    init(service: any PlannerDashboardServiceProtocol) {
        self.service = service
    }

    func fetchDashboard() async throws -> PlannerDashboard {
        try await service.fetchDashboard()
    }
}
