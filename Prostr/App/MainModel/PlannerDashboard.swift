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
    let state: PlannerCardState
    let platform: PlannerPlatform
    let createdAt: Date
    let postDate: Date?
    let imageAssetName: String?

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
}

struct PlannerTodoItem: Identifiable, Hashable {
    let id: String
    let title: String
    let state: PlannerTodoState
    let dueDate: Date
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
