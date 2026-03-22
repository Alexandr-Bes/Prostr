//
//  Color+Hex.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

extension Color {
    init(hex: String, opacity: Double = 1.0) {
        let components = HexColorComponents(hex: hex, opacity: opacity) ?? .clear

        self = Color(
            .sRGB,
            red: components.red,
            green: components.green,
            blue: components.blue,
            opacity: components.alpha
        )
    }
}

struct HexColorComponents: Equatable {
    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double

    static let clear = HexColorComponents(
        red: 0,
        green: 0,
        blue: 0,
        alpha: 0
    )

    init(
        red: Double,
        green: Double,
        blue: Double,
        alpha: Double
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init?(hex: String, opacity: Double = 1.0) {
        let sanitizedHex = Self.sanitizedHex(from: hex)
        let clampedOpacity = opacity.clamped(to: 0...1)

        switch sanitizedHex.count {
        case 3:
            let characters = Array(sanitizedHex)
            let expandedHex = characters.map { "\($0)\($0)" }.joined()
            self.init(hex: expandedHex, opacity: clampedOpacity)

        case 6:
            guard let value = UInt64(sanitizedHex, radix: 16) else {
                return nil
            }

            self.init(
                red: Double((value & 0xFF0000) >> 16) / 255,
                green: Double((value & 0x00FF00) >> 8) / 255,
                blue: Double(value & 0x0000FF) / 255,
                alpha: clampedOpacity
            )

        case 8:
            guard let value = UInt64(sanitizedHex, radix: 16) else {
                return nil
            }

            self.init(
                red: Double((value & 0xFF000000) >> 24) / 255,
                green: Double((value & 0x00FF0000) >> 16) / 255,
                blue: Double((value & 0x0000FF00) >> 8) / 255,
                alpha: (Double(value & 0x000000FF) / 255) * clampedOpacity
            )

        default:
            return nil
        }
    }

    private static func sanitizedHex(from hex: String) -> String {
        let trimmedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let hexWithoutPrefix: String

        if trimmedHex.hasPrefix("#") {
            hexWithoutPrefix = String(trimmedHex.dropFirst())
        } else if trimmedHex.lowercased().hasPrefix("0x") {
            hexWithoutPrefix = String(trimmedHex.dropFirst(2))
        } else {
            hexWithoutPrefix = trimmedHex
        }

        let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")
        let filteredScalars = hexWithoutPrefix.unicodeScalars.filter { allowedCharacters.contains($0) }

        return String(String.UnicodeScalarView(filteredScalars))
    }
}

private extension Double {
    func clamped(to range: ClosedRange<Double>) -> Double {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
