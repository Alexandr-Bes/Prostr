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
                    title: "Travel to Rome Post",
                    subtitle: "Sunset over Roman rooftops, pasta for dinner, and cobblestone walks that...",
                    bodyText: "Sunset over Roman rooftops, pasta for dinner, and cobblestone walks that never end. Rome has a way of making every moment feel timeless. Roman days, golden sunsets, and the magic of getting lost in centuries of history. Some cities you visit once. Rome stays with you forever.",
                    state: .planned,
                    platform: .instagram,
                    postType: .pagePost,
                    createdAt: date(byAddingDays: -2, to: selectedDate, hour: 11, minute: 20),
                    postDate: date(byAddingDays: 0, to: selectedDate, hour: 12, minute: 0),
                    imageAssetName: "sunsetRome",
                    imageData: nil,
                    tag: "travel",
                    detailTags: ["book content", "travel"],
                    hashtags: ["#travel", "#rome", "#italy", "#tag"]
                ),
                PlannerContentCard(
                    id: "linkedin-scheduled-today",
                    title: "Sunset carousel story",
                    subtitle: "A softer brand story post with a behind-the-scenes writing angle.",
                    bodyText: "A softer brand story post built around warm light, a thoughtful voice, and the feeling of slowing down long enough to really notice the place around you. This one leans more reflective and cinematic.",
                    state: .scheduled,
                    platform: .linkedin,
                    postType: .pagePost,
                    createdAt: date(byAddingDays: -1, to: selectedDate, hour: 14, minute: 45),
                    postDate: date(byAddingDays: 0, to: selectedDate, hour: 18, minute: 30),
                    imageAssetName: "colosseumRome",
                    imageData: nil,
                    tag: "brand story",
                    detailTags: ["brand story", "linkedin"],
                    hashtags: ["#brand", "#story", "#linkedin"]
                ),
                PlannerContentCard(
                    id: "instagram-planned-upcoming",
                    title: "Weekend captions batch",
                    subtitle: "A planned post about batch-writing hooks and saving caption drafts.",
                    bodyText: "A practical post focused on building a small caption bank ahead of time so publishing feels lighter during the week. Useful, warm, and still aligned with the Rome travel mood.",
                    state: .planned,
                    platform: .instagram,
                    postType: .pagePost,
                    createdAt: date(byAddingDays: 0, to: selectedDate, hour: 9, minute: 10),
                    postDate: date(byAddingDays: 2, to: selectedDate, hour: 10, minute: 0),
                    imageAssetName: nil,
                    imageData: nil,
                    tag: "content",
                    detailTags: ["content", "planning"],
                    hashtags: ["#content", "#captions", "#workflow"]
                ),
                PlannerContentCard(
                    id: "tiktok-scheduled-upcoming",
                    title: "Columns moodboard clip",
                    subtitle: "A scheduled short clip focused on framing, pacing, and visual texture.",
                    bodyText: "A short-form clip built around columns, light, and motion. The post focuses on visual rhythm and atmosphere more than narration, making it a good fit for TikTok pacing.",
                    state: .scheduled,
                    platform: .tiktok,
                    postType: .pagePost,
                    createdAt: date(byAddingDays: -3, to: selectedDate, hour: 18, minute: 5),
                    postDate: date(byAddingDays: 3, to: selectedDate, hour: 9, minute: 15),
                    imageAssetName: "collonsRome",
                    imageData: nil,
                    tag: "visuals",
                    detailTags: ["visuals", "moodboard"],
                    hashtags: ["#visuals", "#rome", "#tiktok"]
                ),
                PlannerContentCard(
                    id: "tiktok-draft",
                    title: "Behind the scenes draft",
                    subtitle: "A saved draft for a more casual creator-style check-in.",
                    bodyText: "A looser creator update meant to feel spontaneous and human. This draft can evolve into a quick check-in post once the tone and pacing feel right.",
                    state: .draft,
                    platform: .tiktok,
                    postType: .pagePost,
                    createdAt: date(byAddingDays: -1, to: selectedDate, hour: 17, minute: 30),
                    postDate: nil,
                    imageAssetName: "sunsetRome",
                    imageData: nil,
                    tag: "draft",
                    detailTags: ["draft", "creator"],
                    hashtags: ["#draft", "#creator", "#bts"]
                )
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
