//
//  AuthSocialButton.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthSocialButton: View {
    @Environment(\.colorScheme) private var colorScheme

    let provider: AuthProvider
    let action: () -> Void

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        Button(action: action) {
            HStack(spacing: 12) {
                Spacer(minLength: 0)

                AuthProviderIconView(provider: provider)
                    .frame(width: 24, height: 24)

                Text(provider.socialButtonTitle)
                    .font(.headline.weight(.medium))
                    .foregroundStyle(palette.primaryText)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .frame(maxWidth: .infinity)
            .background(
                palette.fieldBackground,
                in: RoundedRectangle(cornerRadius: 12, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(palette.neutralBorder, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
