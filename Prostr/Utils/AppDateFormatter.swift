//
//  AppDateFormatter.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

enum AppDateFormatter {
    private static let relativeFormatter: RelativeDateTimeFormatter = {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter
    }()

    private static let plannerHeaderFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()

    private static let monthTitleFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private static let plannerCardDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, HH:mm"
        return formatter
    }()

    static func relativeString(from date: Date) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: .now).capitalized
    }

    static func plannerHeaderString(from date: Date) -> String {
        plannerHeaderFormatter.string(from: date)
    }

    static func monthTitle(from date: Date) -> String {
        monthTitleFormatter.string(from: date)
    }

    static func plannerCardDateString(from date: Date) -> String {
        plannerCardDateFormatter.string(from: date)
    }
}
