//
//  AuthFieldContainer.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthFieldContainer<FieldContent: View, HelperContent: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    private let label: String
    private let fieldState: AuthFieldState
    private let fieldContent: FieldContent
    private let helperContent: HelperContent

    init(
        label: String,
        fieldState: AuthFieldState,
        @ViewBuilder fieldContent: () -> FieldContent,
        @ViewBuilder helperContent: () -> HelperContent
    ) {
        self.label = label
        self.fieldState = fieldState
        self.fieldContent = fieldContent()
        self.helperContent = helperContent()
    }

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(palette.primaryText)

            HStack(spacing: 12) {
                fieldContent
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
                    .stroke(borderColor(using: palette), lineWidth: borderWidth)
            )

            helperContent
        }
    }
}

private extension AuthFieldContainer {
    var borderWidth: CGFloat {
        fieldState == .focused ? 2 : 1
    }

    func borderColor(using palette: AuthPalette) -> Color {
        switch fieldState {
        case .idle:
            return palette.neutralBorder
        case .focused:
            return palette.accent
        case .error:
            return palette.error
        }
    }
}
