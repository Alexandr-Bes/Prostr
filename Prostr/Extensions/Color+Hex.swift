//
//  Color+Hex.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let normalizedHex = Self.normalizedHexString(from: hex)
        let resolvedOpacity = min(max(opacity, 0), 1)

        guard let rgba = Self.rgbaComponents(from: normalizedHex, opacity: resolvedOpacity) else {
            assertionFailure("Invalid hex color value: \(hex)")
            self = .clear
            return
        }

        self = Color(
            .sRGB,
            red: rgba.red,
            green: rgba.green,
            blue: rgba.blue,
            opacity: rgba.alpha
        )
    }
}

private extension Color {
    struct RGBAComponents {
        let red: Double
        let green: Double
        let blue: Double
        let alpha: Double
    }

    static func normalizedHexString(from hex: String) -> String {
        let trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)

        if trimmedHex.hasPrefix("#") {
            return String(trimmedHex.dropFirst())
        }

        if trimmedHex.lowercased().hasPrefix("0x") {
            return String(trimmedHex.dropFirst(2))
        }

        return trimmedHex
    }

    static func rgbaComponents(from hex: String, opacity: Double) -> RGBAComponents? {
        switch hex.count {
        case 3:
            let characters = Array(hex)
            let expandedHex = characters.map { "\($0)\($0)" }.joined()
            return rgbaComponents(from: expandedHex, opacity: opacity)

        case 6:
            guard let value = UInt32(hex, radix: 16) else {
                return nil
            }

            return RGBAComponents(
                red: Double((value & 0xFF0000) >> 16) / 255,
                green: Double((value & 0x00FF00) >> 8) / 255,
                blue: Double(value & 0x0000FF) / 255,
                alpha: opacity
            )

        case 8:
            guard let value = UInt32(hex, radix: 16) else {
                return nil
            }

            return RGBAComponents(
                red: Double((value & 0xFF000000) >> 24) / 255,
                green: Double((value & 0x00FF0000) >> 16) / 255,
                blue: Double((value & 0x0000FF00) >> 8) / 255,
                alpha: Double(value & 0x000000FF) / 255 * opacity
            )

        default:
            return nil
        }
    }
}
