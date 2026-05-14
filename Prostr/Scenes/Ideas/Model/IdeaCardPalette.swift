//
//  IdeaCardPalette.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import SwiftUI

enum IdeaCardPalette: Hashable {
    case sage
    case sky

    var backgroundColor: Color {
        switch self {
        case .sage:
            return Color(hex: "E2F4F5")
        case .sky:
            return Color(hex: "E5F4FF")
        }
    }

    var cornerAccentColor: Color {
        switch self {
        case .sage:
            return Color(hex: "609392")
        case .sky:
            return Color(hex: "2883C9")
        }
    }

    static func palette(for ordinal: Int) -> IdeaCardPalette {
        ordinal.isMultiple(of: 2) ? .sage : .sky
    }
}
