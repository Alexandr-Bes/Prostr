//
//  AuthFooterPromptView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthFooterPromptView: View {
    @Environment(\.colorScheme) private var colorScheme

    let message: String
    let actionTitle: String
    let action: () -> Void

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        HStack(spacing: 6) {
            Text(message)
                .font(.body)
                .foregroundStyle(palette.primaryText)

            Button(actionTitle, action: action)
                .font(.body)
                .foregroundStyle(palette.accent)
        }
    }
}
