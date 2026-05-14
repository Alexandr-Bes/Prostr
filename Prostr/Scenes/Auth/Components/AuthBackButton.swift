//
//  AuthBackButton.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthBackButton: View {
    @Environment(\.colorScheme) private var colorScheme

    let action: () -> Void

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        Button("Back", systemImage: "chevron.left", action: action)
            .labelStyle(.iconOnly)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(palette.primaryText)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .accessibilityLabel("Go back")
    }
}
