//
//  AuthDividerView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthDividerView: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        HStack(spacing: 20) {
            Rectangle()
                .fill(palette.divider)
                .frame(height: 1)

            Text("or")
                .font(.body)
                .foregroundStyle(palette.secondaryText)

            Rectangle()
                .fill(palette.divider)
                .frame(height: 1)
        }
    }
}
