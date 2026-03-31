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

        let calendar = Calendar(identifier: .gregorian)
        let referenceDashboard = PlannerDashboardMockData.dashboard
        let referenceDate = referenceDashboard.selectedDate

        let cards = response.enumerated().map { index, item in
            let state = PlannerCardState(rawValue: item.accentStyle) ?? .planned
            let scheduledDate = calendar.date(byAdding: .day, value: index, to: referenceDate) ?? referenceDate

            return PlannerContentCard(
                id: item.id,
                title: item.title,
                subtitle: item.subtitle,
                bodyText: item.detail,
                state: state,
                platform: .instagram,
                postType: .pagePost,
                createdAt: calendar.date(byAdding: .day, value: -1, to: scheduledDate) ?? scheduledDate,
                postDate: state == .draft ? nil : scheduledDate,
                imageAssetName: nil,
                imageData: nil,
                tag: nil,
                detailTags: [],
                hashtags: []
            )
        }

        return PlannerDashboard(
            screenTitle: "Plan",
            visibleMonth: referenceDashboard.visibleMonth,
            selectedDate: referenceDashboard.selectedDate,
            cards: cards,
            todoItems: [
                PlannerTodoItem(id: "remote-script", title: "Write the script outline", state: .today, dueDate: referenceDate),
                PlannerTodoItem(id: "remote-audio", title: "Confirm the audio direction", state: .default, dueDate: referenceDate),
                PlannerTodoItem(id: "remote-caption", title: "Finalize the caption", state: .overdue, dueDate: calendar.date(byAdding: .day, value: -1, to: referenceDate) ?? referenceDate),
                PlannerTodoItem(id: "remote-cover", title: "Export the cover image", state: .checked, dueDate: calendar.date(byAdding: .day, value: 2, to: referenceDate) ?? referenceDate)
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
