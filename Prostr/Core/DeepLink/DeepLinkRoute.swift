//
//  DeepLinkRoute.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

enum DeepLinkRoute: Hashable {
    case tab(AppTab)
    case calendar(date: Date)
    case feature(id: String)

    init?(storageValue: String) {
        if storageValue.hasPrefix("calendar:") {
            let rawDate = String(storageValue.dropFirst(9))
            guard let date = AppDateFormatter.plannerDeepLinkDate(from: rawDate) else { return nil }
            self = .calendar(date: date)
            return
        }

        if storageValue.hasPrefix("tab:") {
            let rawValue = String(storageValue.dropFirst(4))
            guard let tab = AppTab(rawValue: rawValue) else { return nil }
            self = .tab(tab)
            return
        }

        if storageValue.hasPrefix("feature:") {
            let id = String(storageValue.dropFirst(8))
            guard !id.isEmpty else { return nil }
            self = .feature(id: id)
            return
        }

        return nil
    }

    var storageValue: String {
        switch self {
        case let .tab(tab):
            return "tab:\(tab.rawValue)"
        case let .calendar(date):
            return "calendar:\(AppDateFormatter.plannerDeepLinkDateString(from: date))"
        case let .feature(id):
            return "feature:\(id)"
        }
    }

    var title: String {
        switch self {
        case let .tab(tab):
            return "Open \(tab.title)"
        case let .calendar(date):
            return "Open calendar for \(AppDateFormatter.plannerLongDateString(from: date))"
        case let .feature(id):
            return "Open feature: \(id)"
        }
    }
}
