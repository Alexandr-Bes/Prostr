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
    let ambientGlowTop: Color
    let ambientGlowBottom: Color
    let cardBackground: Color
    let secondaryCardBackground: Color
    let overlaySurface: Color
    let cardBorder: Color
    let cardShadow: Color
    let primaryText: Color
    let secondaryText: Color
    let tertiaryText: Color
    let inverseText: Color
    let successTint: Color
    let warningTint: Color
    let dangerTint: Color
    let accentSoft: Color
    let heroStart: Color
    let heroEnd: Color
    let tabBarBackground: Color
    let tabBarInactiveBackground: Color
    let tabBarActiveBackground: Color

    static let `default` = AppTheme(
        accentTint: Color(red: 0.86, green: 0.45, blue: 0.31),
        canvasTop: Color(red: 0.98, green: 0.96, blue: 0.93),
        canvasBottom: Color(red: 0.93, green: 0.89, blue: 0.83),
        ambientGlowTop: Color(red: 0.99, green: 0.86, blue: 0.76, opacity: 0.75),
        ambientGlowBottom: Color(red: 0.37, green: 0.31, blue: 0.26, opacity: 0.10),
        cardBackground: Color(red: 0.99, green: 0.97, blue: 0.95),
        secondaryCardBackground: Color(red: 0.95, green: 0.91, blue: 0.86),
        overlaySurface: Color(red: 0.12, green: 0.11, blue: 0.10, opacity: 0.05),
        cardBorder: Color(red: 0.16, green: 0.14, blue: 0.11, opacity: 0.08),
        cardShadow: Color(red: 0.15, green: 0.12, blue: 0.10, opacity: 0.12),
        primaryText: Color(red: 0.12, green: 0.11, blue: 0.10),
        secondaryText: Color(red: 0.38, green: 0.34, blue: 0.30),
        tertiaryText: Color(red: 0.59, green: 0.54, blue: 0.49),
        inverseText: Color.white,
        successTint: Color(red: 0.24, green: 0.53, blue: 0.41),
        warningTint: Color(red: 0.79, green: 0.54, blue: 0.21),
        dangerTint: Color(red: 0.80, green: 0.35, blue: 0.29),
        accentSoft: Color(red: 0.98, green: 0.89, blue: 0.84),
        heroStart: Color(red: 0.18, green: 0.16, blue: 0.15),
        heroEnd: Color(red: 0.36, green: 0.31, blue: 0.28),
        tabBarBackground: Color(red: 0.98, green: 0.96, blue: 0.93),
        tabBarInactiveBackground: Color(red: 0.94, green: 0.90, blue: 0.84),
        tabBarActiveBackground: Color(red: 0.16, green: 0.15, blue: 0.14)
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
