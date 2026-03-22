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

    private static let plannerDeepLinkDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let plannerLongDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
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

    static func plannerDeepLinkDateString(from date: Date) -> String {
        plannerDeepLinkDateFormatter.string(from: date)
    }

    static func plannerDeepLinkDate(from string: String) -> Date? {
        plannerDeepLinkDateFormatter.date(from: string)
    }

    static func plannerLongDateString(from date: Date) -> String {
        plannerLongDateFormatter.string(from: date)
    }
}
