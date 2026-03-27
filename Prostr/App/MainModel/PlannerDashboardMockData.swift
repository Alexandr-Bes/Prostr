//
//  PlannerDashboardMockData.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import Foundation

enum PlannerDashboardMockData {
    nonisolated static var dashboard: PlannerDashboard {
        makeDashboard(referenceDate: .now)
    }

    nonisolated static func makeDashboard(referenceDate: Date) -> PlannerDashboard {
        let calendar = Calendar(identifier: .gregorian)
        let selectedDate = calendar.startOfDay(for: referenceDate)
        let visibleMonth = calendar.date(
            from: calendar.dateComponents([.year, .month], from: selectedDate)
        ) ?? selectedDate

        return PlannerDashboard(
            screenTitle: "Plan",
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            cards: [
                PlannerContentCard(
                    id: "instagram-planned-today",
                    title: "Rome city guide reel",
                    subtitle: "A warm travel opener with a city-detail hook and location tips.",
                    state: .planned,
                    platform: .instagram,
                    createdAt: date(byAddingDays: -2, to: selectedDate, hour: 11, minute: 20),
                    postDate: date(byAddingDays: 0, to: selectedDate, hour: 12, minute: 0),
                    imageAssetName: "colosseumRome",
                    tag: "travel"
                ),
                PlannerContentCard(
                    id: "linkedin-scheduled-today",
                    title: "Sunset carousel story",
                    subtitle: "A softer brand story post with a behind-the-scenes writing angle.",
                    state: .scheduled,
                    platform: .linkedin,
                    createdAt: date(byAddingDays: -1, to: selectedDate, hour: 14, minute: 45),
                    postDate: date(byAddingDays: 0, to: selectedDate, hour: 18, minute: 30),
                    imageAssetName: "sunsetRome",
                    tag: "brand story"
                ),
                PlannerContentCard(
                    id: "instagram-planned-upcoming",
                    title: "Weekend captions batch",
                    subtitle: "A planned post about batch-writing hooks and saving caption drafts.",
                    state: .planned,
                    platform: .instagram,
                    createdAt: date(byAddingDays: 0, to: selectedDate, hour: 9, minute: 10),
                    postDate: date(byAddingDays: 2, to: selectedDate, hour: 10, minute: 0),
                    imageAssetName: nil,
                    tag: "content"
                ),
                PlannerContentCard(
                    id: "tiktok-scheduled-upcoming",
                    title: "Columns moodboard clip",
                    subtitle: "A scheduled short clip focused on framing, pacing, and visual texture.",
                    state: .scheduled,
                    platform: .tiktok,
                    createdAt: date(byAddingDays: -3, to: selectedDate, hour: 18, minute: 5),
                    postDate: date(byAddingDays: 3, to: selectedDate, hour: 9, minute: 15),
                    imageAssetName: "collonsRome",
                    tag: "visuals"
                )//,
//                PlannerContentCard(
//                    id: "tiktok-draft",
//                    title: "Behind the scenes draft",
//                    subtitle: "A saved draft for a more casual creator-style check-in.",
//                    state: .draft,
//                    platform: .tiktok,
//                    createdAt: date(byAddingDays: -1, to: selectedDate, hour: 17, minute: 30),
//                    postDate: nil,
//                    imageAssetName: "sunsetRome",
//                    tag: "draft"
//                )
            ],
            todoItems: [
                PlannerTodoItem(
                    id: "script",
                    title: "Write the opening hook",
                    state: .today,
                    dueDate: date(byAddingDays: 0, to: selectedDate, hour: 9, minute: 0)
                ),
                PlannerTodoItem(
                    id: "audio",
                    title: "Pick the audio reference",
                    state: .default,
                    dueDate: date(byAddingDays: 0, to: selectedDate, hour: 11, minute: 0)
                ),
                PlannerTodoItem(
                    id: "hashtags",
                    title: "Prepare hashtags and keywords",
                    state: .checked,
                    dueDate: date(byAddingDays: 0, to: selectedDate, hour: 14, minute: 30)
                ),
                PlannerTodoItem(
                    id: "cover",
                    title: "Prepare the cover layout",
                    state: .overdue,
                    dueDate: date(byAddingDays: -1, to: selectedDate, hour: 13, minute: 0)
                ),
                PlannerTodoItem(
                    id: "review",
                    title: "Review the final scheduled post",
                    state: .default,
                    dueDate: date(byAddingDays: 2, to: selectedDate, hour: 16, minute: 0)
                )
            ],
            ideas: [
                PlannerIdea(id: "idea-1", title: "Weekly creator check-in", note: "A recurring diary-style update that works as both a reel and a TikTok.", tag: "Routine"),
                PlannerIdea(id: "idea-2", title: "Client feedback breakdown", note: "Turn one client note into a concise LinkedIn story and visual carousel.", tag: "LinkedIn"),
                PlannerIdea(id: "idea-3", title: "Editing workflow shortcuts", note: "A quick swipe list of favorite shortcuts, presets, and save-time tricks.", tag: "Tips")
            ]
        )
    }
}

private nonisolated func date(
    byAddingDays days: Int,
    to baseDate: Date,
    hour: Int,
    minute: Int
) -> Date {
    let calendar = Calendar(identifier: .gregorian)
    let shiftedDate = calendar.date(byAdding: .day, value: days, to: baseDate) ?? baseDate
    let components = calendar.dateComponents([.year, .month, .day], from: shiftedDate)

    return calendar.date(
        from: DateComponents(
            year: components.year,
            month: components.month,
            day: components.day,
            hour: hour,
            minute: minute
        )
    ) ?? baseDate
}
