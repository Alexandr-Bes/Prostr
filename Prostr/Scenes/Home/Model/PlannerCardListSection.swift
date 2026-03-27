//
//  PlannerCardListSection.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 24.03.2026.
//

import Foundation

enum PlannerCardFilter: String, CaseIterable, Identifiable, Hashable {
    case all
    case drafts
    case planned
    case scheduled

    var id: String { rawValue }

    var title: String {
        switch self {
        case .all:
            return "All"
        case .drafts:
            return "Drafts"
        case .planned:
            return "Planned"
        case .scheduled:
            return "Scheduled"
        }
    }

    func matches(_ card: PlannerContentCard) -> Bool {
        switch self {
        case .all:
            return true
        case .drafts:
            return card.state == .draft
        case .planned:
            return card.state == .planned
        case .scheduled:
            return card.state == .scheduled
        }
    }
}

struct PlannerCardListSection: Identifiable, Hashable {
    let id: String
    let title: String?
    let cards: [PlannerContentCard]
}
