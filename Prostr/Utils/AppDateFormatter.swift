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

    static func relativeString(from date: Date) -> String {
        relativeFormatter.localizedString(for: date, relativeTo: .now).capitalized
    }
}
