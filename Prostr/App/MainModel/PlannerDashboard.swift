//
//  PlannerDashboard.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

struct PlannerDashboard: Hashable {
    let screenTitle: String
    let visibleMonth: Date
    let selectedDate: Date
    let cards: [PlannerContentCard]
    let todoItems: [PlannerTodoItem]
    let ideas: [PlannerIdea]
}

struct PlannerContentCard: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let bodyText: String
    let state: PlannerCardState
    let platform: PlannerPlatform
    let postType: PlannerPostType
    let createdAt: Date
    let postDate: Date?
    let imageAssetName: String?
    let imageData: Data?
    let tag: String?
    let detailTags: [String]
    let hashtags: [String]

    var effectiveDisplayDate: Date {
        postDate ?? createdAt
    }

    var calendarMarker: PlannerCalendarMarker? {
        switch state {
        case .planned:
            return .planned
        case .scheduled:
            return .scheduled
        case .draft:
            return nil
        }
    }
}

enum PlannerPostType: String, Hashable {
    case pagePost

    var title: String {
        switch self {
        case .pagePost:
            return "Page Post"
        }
    }

    var systemImage: String {
        switch self {
        case .pagePost:
            return "menucard"
        }
    }
}

enum PlannerCardState: String, Hashable {
    case planned
    case scheduled
    case draft

    var title: String {
        rawValue.capitalized
    }
}

enum PlannerPlatform: String, Hashable {
    case instagram
    case linkedin
    case tiktok

    var title: String {
        switch self {
        case .instagram:
            return "Instagram"
        case .linkedin:
            return "LinkedIn"
        case .tiktok:
            return "TikTok"
        }
    }

    var shortTitle: String {
        switch self {
        case .instagram:
            return "IG"
        case .linkedin:
            return "IN"
        case .tiktok:
            return "TT"
        }
    }

    var avatarAssetName: String? {
        switch self {
        case .instagram:
            return "avatarInsta"
        case .linkedin:
            return "avatarLinkedin"
        case .tiktok:
            return "avatarTikTok"
        }
    }
}

struct PlannerTodoItem: Identifiable, Hashable {
    let id: String
    let title: String
    let state: PlannerTodoState
    let dueDate: Date

    var isCompleted: Bool {
        state == .checked
    }
}

enum PlannerTodoState: Hashable {
    case `default`
    case checked
    case today
    case overdue

    var title: String {
        switch self {
        case .default:
            return "Default"
        case .checked:
            return "Checked"
        case .today:
            return "Today"
        case .overdue:
            return "Overdue"
        }
    }
}

extension PlannerDashboard {
    func updating(cards: [PlannerContentCard]) -> PlannerDashboard {
        PlannerDashboard(
            screenTitle: screenTitle,
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            cards: cards,
            todoItems: todoItems,
            ideas: ideas
        )
    }

    func updating(todoItems: [PlannerTodoItem]) -> PlannerDashboard {
        PlannerDashboard(
            screenTitle: screenTitle,
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            cards: cards,
            todoItems: todoItems,
            ideas: ideas
        )
    }

    func updating(contentCard: PlannerContentCard) -> PlannerDashboard {
        PlannerDashboard(
            screenTitle: screenTitle,
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            cards: cards.map { existingCard in
                existingCard.id == contentCard.id ? contentCard : existingCard
            },
            todoItems: todoItems,
            ideas: ideas
        )
    }
}

extension PlannerTodoItem {
    func toggled(relativeTo referenceDate: Date, calendar: Calendar) -> PlannerTodoItem {
        PlannerTodoItem(
            id: id,
            title: title,
            state: PlannerTodoState.toggledState(
                current: state,
                dueDate: dueDate,
                referenceDate: referenceDate,
                calendar: calendar
            ),
            dueDate: dueDate
        )
    }
}

extension PlannerTodoState {
    static func state(
        for dueDate: Date,
        referenceDate: Date,
        calendar: Calendar
    ) -> PlannerTodoState {
        let normalizedReferenceDate = calendar.startOfDay(for: referenceDate)
        let normalizedDueDate = calendar.startOfDay(for: dueDate)

        if calendar.isDate(normalizedDueDate, inSameDayAs: normalizedReferenceDate) {
            return .today
        }

        if normalizedDueDate < normalizedReferenceDate {
            return .overdue
        }

        return .default
    }

    static func toggledState(
        current: PlannerTodoState,
        dueDate: Date,
        referenceDate: Date,
        calendar: Calendar
    ) -> PlannerTodoState {
        guard current == .checked else {
            return .checked
        }

        return state(
            for: dueDate,
            referenceDate: referenceDate,
            calendar: calendar
        )
    }
}

extension PlannerContentCard {
    func updating(
        title: String,
        bodyText: String,
        state: PlannerCardState,
        imageAssetName: String?,
        imageData: Data?,
        detailTags: [String],
        hashtags: [String],
        fallbackPostDate: Date? = nil
    ) -> PlannerContentCard {
        let normalizedTags = detailTags
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
        let normalizedHashtags = hashtags
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return PlannerContentCard(
            id: id,
            title: title,
            subtitle: Self.makeSubtitle(from: bodyText),
            bodyText: bodyText,
            state: state,
            platform: platform,
            postType: postType,
            createdAt: createdAt,
            postDate: state == .draft ? nil : (postDate ?? fallbackPostDate ?? createdAt),
            imageAssetName: imageData == nil ? imageAssetName : nil,
            imageData: imageData,
            tag: normalizedTags.last,
            detailTags: normalizedTags,
            hashtags: normalizedHashtags
        )
    }

    static func makeDraft(
        postDate: Date,
        createdAt: Date = .now,
        platform: PlannerPlatform = .instagram,
        postType: PlannerPostType = .pagePost
    ) -> PlannerContentCard {
        PlannerContentCard(
            id: UUID().uuidString,
            title: "",
            subtitle: "",
            bodyText: "",
            state: .draft,
            platform: platform,
            postType: postType,
            createdAt: createdAt,
            postDate: postDate,
            imageAssetName: nil,
            imageData: nil,
            tag: nil,
            detailTags: [],
            hashtags: []
        )
    }

    private static func makeSubtitle(from bodyText: String) -> String {
        let normalizedText = bodyText
            .replacingOccurrences(of: "\n", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        guard normalizedText.count > 72 else {
            return normalizedText
        }

        let endIndex = normalizedText.index(normalizedText.startIndex, offsetBy: 72)
        return normalizedText[..<endIndex].trimmingCharacters(in: .whitespacesAndNewlines) + "..."
    }
}

struct PlannerIdea: Identifiable, Hashable {
    let id: String
    let title: String
    let note: String
    let tag: String
}

enum PlannerHomeMode: String, CaseIterable, Identifiable, Hashable {
    case calendar
    case list

    var id: String { rawValue }

    var title: String {
        rawValue.capitalized
    }

    var systemImage: String {
        switch self {
        case .calendar:
            return "calendar"
        case .list:
            return "list.bullet"
        }
    }
}

enum PlannerCalendarDisplayMode: String, Hashable {
    case month
    case week

    mutating func toggle() {
        self = self == .month ? .week : .month
    }
}

enum PlannerCalendarMarker: String, Hashable, CaseIterable {
    case scheduled
    case planned

    var sortOrder: Int {
        switch self {
        case .scheduled:
            return 0
        case .planned:
            return 1
        }
    }
}

struct PlannerCalendarDay: Identifiable, Hashable {
    let id: String
    let date: Date
    let dayNumber: Int
    let isSelected: Bool
    let isWithinDisplayedMonth: Bool
    let markers: [PlannerCalendarMarker]
}
