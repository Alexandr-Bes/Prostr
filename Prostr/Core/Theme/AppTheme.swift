//
//  AppTheme.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct AppTheme {
    let accentTint: Color
    let background: Color
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

    static let light = AppTheme(
        accentTint: Color(hex: "E6774A"),
        background: Color(hex: "FAFAFC"),
        ambientGlowTop: Color(hex: "FFE2C8", opacity: 0.75),
        ambientGlowBottom: Color(hex: "5E5044", opacity: 0.10),
        cardBackground: .white,
        secondaryCardBackground: Color(hex: "F5EFE8"),
        overlaySurface: Color(hex: "1F1C1A", opacity: 0.05),
        cardBorder: Color(hex: "1F1C1A", opacity: 0.08),
        cardShadow: Color(hex: "261F1A", opacity: 0.12),
        primaryText: Color(hex: "201D1B"),
        secondaryText: Color(hex: "625852"),
        tertiaryText: Color(hex: "9A8F87"),
        inverseText: .white,
        successTint: Color(hex: "4CA67A"),
        warningTint: Color(hex: "C98844"),
        dangerTint: Color(hex: "D55E4B"),
        accentSoft: Color(hex: "FDEADF"),
        heroStart: Color(hex: "2E2926"),
        heroEnd: Color(hex: "5C4F46"),
        tabBarBackground: Color(hex: "FAF7F2"),
        tabBarInactiveBackground: Color(hex: "EEE8E1"),
        tabBarActiveBackground: Color(hex: "1E1B1A")
    )

    static let dark = AppTheme(
        accentTint: Color(hex: "F08A5F"),
        background: Color(hex: "090909"),
        ambientGlowTop: Color(hex: "40271C", opacity: 0.35),
        ambientGlowBottom: Color(hex: "050505", opacity: 0.18),
        cardBackground: .black,
        secondaryCardBackground: Color(hex: "141414"),
        overlaySurface: Color.white.opacity(0.06),
        cardBorder: Color.white.opacity(0.08),
        cardShadow: Color.black.opacity(0.42),
        primaryText: Color(hex: "F8F6F3"),
        secondaryText: Color(hex: "B5AEA8"),
        tertiaryText: Color(hex: "7F7A75"),
        inverseText: .black,
        successTint: Color(hex: "62C297"),
        warningTint: Color(hex: "E2A86B"),
        dangerTint: Color(hex: "F08C7A"),
        accentSoft: Color(hex: "2A211C"),
        heroStart: Color(hex: "050505"),
        heroEnd: Color(hex: "151515"),
        tabBarBackground: Color(hex: "0D0D0D"),
        tabBarInactiveBackground: Color(hex: "1A1A1A"),
        tabBarActiveBackground: Color(hex: "F7F3EE")
    )

    static let `default` = light
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
