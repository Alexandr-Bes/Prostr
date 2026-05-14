//
//  AuthHelperTextView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthHelperTextView: View {
    @Environment(\.colorScheme) private var colorScheme

    let message: String

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        Label {
            Text(message)
                .font(.footnote)
                .foregroundStyle(palette.error)
        } icon: {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(palette.error)
        }
    }
}
