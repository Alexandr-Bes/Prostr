//
//  AppTheme.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct AppTheme {
    let accentTint: Color
    let canvasTop: Color
    let canvasBottom: Color
    let cardBackground: Color
    let overlaySurface: Color
    let cardBorder: Color
    let cardShadow: Color
    let primaryText: Color
    let secondaryText: Color
    let heroStart: Color
    let heroEnd: Color

    static let `default` = AppTheme(
        accentTint: .indigo,
        canvasTop: Color(red: 0.97, green: 0.98, blue: 1.0),
        canvasBottom: Color(red: 0.92, green: 0.95, blue: 1.0),
        cardBackground: .white.opacity(0.9),
        overlaySurface: Color.black.opacity(0.05),
        cardBorder: Color.white.opacity(0.72),
        cardShadow: Color.indigo.opacity(0.12),
        primaryText: Color(red: 0.08, green: 0.11, blue: 0.18),
        secondaryText: Color(red: 0.31, green: 0.36, blue: 0.47),
        heroStart: .indigo,
        heroEnd: .cyan
    )
}

private struct AppThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme.default
}

extension EnvironmentValues {
    var appTheme: AppTheme {
        get { self[AppThemeKey.self] }
        set { self[AppThemeKey.self] = newValue }
    }
}

extension View {
    func appTheme(_ theme: AppTheme) -> some View {
        environment(\.appTheme, theme)
    }
}
