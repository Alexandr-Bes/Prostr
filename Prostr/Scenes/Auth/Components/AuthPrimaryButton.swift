//
//  AuthPrimaryButton.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthPrimaryButton: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        Button(action: action) {
            ZStack {
                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .opacity(isLoading ? 0 : 1)

                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                palette.accent,
                in: Capsule()
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
        .opacity(isLoading ? 0.9 : 1)
    }
}
