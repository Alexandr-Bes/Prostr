//
//  ThemeService.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import SwiftUI

enum ThemeMode: String, CaseIterable, Identifiable, Codable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system:
            return "System"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

@MainActor
protocol ThemeServiceProtocol {
    var theme: AppTheme { get }
    func loadThemeMode() -> ThemeMode
    func saveThemeMode(_ mode: ThemeMode)
}

@MainActor
final class ThemeService: ThemeServiceProtocol {
    private let localStorage: any LocalStorageAdapter

    private enum ThemeStorageKey: String, KeyValueStorageKey {
        case preferredThemeMode = "preferred_theme_mode"
    }

    init(localStorage: any LocalStorageAdapter) {
        self.localStorage = localStorage
    }

    var theme: AppTheme {
        .default
    }

    func loadThemeMode() -> ThemeMode {
        let rawValue: String = localStorage.get(for: ThemeStorageKey.preferredThemeMode, default: ThemeMode.system.rawValue)
        return ThemeMode(rawValue: rawValue) ?? .system
    }

    func saveThemeMode(_ mode: ThemeMode) {
        localStorage.set(mode.rawValue, for: ThemeStorageKey.preferredThemeMode)
    }
}
