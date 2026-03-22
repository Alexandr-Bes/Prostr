//
//  AppTab.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

enum AppTab: String, CaseIterable, Hashable, Identifiable {
    case calendar
    case todo
    case ideas

    var id: String { rawValue }

    var title: String {
        switch self {
        case .calendar:
            return "Calendar"
        case .todo:
            return "To-do"
        case .ideas:
            return "Ideas"
        }
    }

    var systemImage: String {
        switch self {
        case .calendar:
            return "calendar"
        case .todo:
            return "checkmark.circle"
        case .ideas:
            return "sparkles"
        }
    }
}
