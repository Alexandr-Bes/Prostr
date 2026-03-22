//
//  PlannerDashboardService.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

protocol PlannerDashboardServiceProtocol {
    nonisolated func fetchDashboard() async throws -> PlannerDashboard
}

nonisolated struct PlannerDashboardEndpoint: APIEndpoint {
    let path = "/starter-highlights"
    let method: HTTPMethod = .get
}

nonisolated struct PlannerDashboardCardResponse: Decodable {
    let id: String
    let title: String
    let subtitle: String
    let detail: String
    let symbolName: String
    let accentStyle: String
}

nonisolated struct LivePlannerDashboardService: PlannerDashboardServiceProtocol {
    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    nonisolated func fetchDashboard() async throws -> PlannerDashboard {
        let response = try await networkClient.send(
            PlannerDashboardEndpoint(),
            responseType: [PlannerDashboardCardResponse].self
        )

        let cards = response.map { item in
            PlannerContentCard(
                id: item.id,
                title: item.title,
                subtitle: item.subtitle,
                state: PlannerCardState(rawValue: item.accentStyle) ?? .planned,
                platform: .instagram,
                createdAt: .now,
                postDate: nil,
                imageAssetName: nil
            )
        }

        return PlannerDashboard(
            screenTitle: "Plan",
            visibleMonth: PlannerDashboardMockData.dashboard.visibleMonth,
            selectedDate: PlannerDashboardMockData.dashboard.selectedDate,
            markedDayNumbers: PlannerDashboardMockData.dashboard.markedDayNumbers,
            cards: cards,
            todoItems: [
                PlannerTodoItem(id: "remote-script", title: "Write the script outline", state: .today),
                PlannerTodoItem(id: "remote-audio", title: "Confirm the audio direction", state: .default),
                PlannerTodoItem(id: "remote-caption", title: "Finalize the caption", state: .overdue),
                PlannerTodoItem(id: "remote-cover", title: "Export the cover image", state: .checked)
            ],
            ideas: [
                PlannerIdea(id: "remote-series", title: "Creator routine series", note: "Turn a weekly workflow into a repeatable short-form story sequence.", tag: "Series")
            ]
        )
    }
}

nonisolated struct MockPlannerDashboardService: PlannerDashboardServiceProtocol {
    nonisolated func fetchDashboard() async throws -> PlannerDashboard {
        try await Task.sleep(for: .milliseconds(200))
        return PlannerDashboardMockData.dashboard
    }
}
