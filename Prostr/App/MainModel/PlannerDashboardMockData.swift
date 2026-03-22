//
//  PlannerDashboardMockData.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import Foundation

enum PlannerDashboardMockData {
    nonisolated static let dashboard = PlannerDashboard(
        screenTitle: "Plan",
        visibleMonth: plannerDate(year: 2026, month: 3, day: 1),
        selectedDate: plannerDate(year: 2026, month: 3, day: 8),
        markedDayNumbers: [3, 8, 10, 14, 18, 21, 24, 29],
        cards: [
            PlannerContentCard(
                id: "instagram-planned",
                title: "Rome city guide reel",
                subtitle: "A warm travel opener with a city-detail hook and location tips.",
                state: .planned,
                platform: .instagram,
                createdAt: plannerDate(year: 2026, month: 3, day: 2, hour: 11, minute: 20),
                postDate: plannerDate(year: 2026, month: 3, day: 8, hour: 12, minute: 0),
                imageAssetName: "colosseumRome"
            ),
            PlannerContentCard(
                id: "linkedin-scheduled",
                title: "Sunset carousel story",
                subtitle: "A softer brand story post with a behind-the-scenes writing angle.",
                state: .scheduled,
                platform: .linkedin,
                createdAt: plannerDate(year: 2026, month: 3, day: 4, hour: 14, minute: 45),
                postDate: plannerDate(year: 2026, month: 3, day: 10, hour: 9, minute: 30),
                imageAssetName: "sunsetRome"
            ),
            PlannerContentCard(
                id: "tiktok-draft",
                title: "Columns moodboard clip",
                subtitle: "A saved draft focused on framing, pacing, and visual texture.",
                state: .draft,
                platform: .tiktok,
                createdAt: plannerDate(year: 2026, month: 3, day: 7, hour: 18, minute: 5),
                postDate: nil,
                imageAssetName: "collonsRome"
            )
        ],
        todoItems: [
            PlannerTodoItem(id: "script", title: "Write the opening hook", state: .today),
            PlannerTodoItem(id: "audio", title: "Pick the audio reference", state: .default),
            PlannerTodoItem(id: "hashtags", title: "Prepare hashtags and keywords", state: .checked),
            PlannerTodoItem(id: "cover", title: "Prepare the cover layout", state: .overdue)
        ],
        ideas: [
            PlannerIdea(id: "idea-1", title: "Weekly creator check-in", note: "A recurring diary-style update that works as both a reel and a TikTok.", tag: "Routine"),
            PlannerIdea(id: "idea-2", title: "Client feedback breakdown", note: "Turn one client note into a concise LinkedIn story and visual carousel.", tag: "LinkedIn"),
            PlannerIdea(id: "idea-3", title: "Editing workflow shortcuts", note: "A quick swipe list of favorite shortcuts, presets, and save-time tricks.", tag: "Tips")
        ]
    )
}

private func plannerDate(year: Int, month: Int, day: Int, hour: Int = 12, minute: Int = 0) -> Date {
    Calendar(identifier: .gregorian).date(
        from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
    ) ?? .now
}
