//
//  AuthPalette.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthPalette {
    let background: Color
    let fieldBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let placeholderText: Color
    let accent: Color
    let neutralBorder: Color
    let error: Color
    let divider: Color

    init(colorScheme: ColorScheme) {
        switch colorScheme {
        case .light:
            background = Color(hex: "FAFAFC")
            fieldBackground = .white
            primaryText = Color(hex: "1C1B1F")
            secondaryText = Color(hex: "6F6F74")
            placeholderText = Color(hex: "9B9C9E")
            accent = Color(hex: "2883C9")
            neutralBorder = Color(hex: "1C1B1F", opacity: 0.45)
            error = Color(hex: "FF4D4F")
            divider = Color(hex: "E9E9E9")
        case .dark:
            background = Color(hex: "090909")
            fieldBackground = Color(hex: "141414")
            primaryText = Color(hex: "F5F5F7")
            secondaryText = Color(hex: "B1B1B8")
            placeholderText = Color(hex: "7D7E87")
            accent = Color(hex: "4FA1E1")
            neutralBorder = Color.white.opacity(0.18)
            error = Color(hex: "FF7B76")
            divider = Color.white.opacity(0.12)
        @unknown default:
            background = Color(hex: "FAFAFC")
            fieldBackground = .white
            primaryText = Color(hex: "1C1B1F")
            secondaryText = Color(hex: "6F6F74")
            placeholderText = Color(hex: "9B9C9E")
            accent = Color(hex: "2883C9")
            neutralBorder = Color(hex: "1C1B1F", opacity: 0.45)
            error = Color(hex: "FF4D4F")
            divider = Color(hex: "E9E9E9")
        }
    }
}
