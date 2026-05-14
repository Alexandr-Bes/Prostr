//
//  AuthPasswordRequirementsView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthPasswordRequirementsView: View {
    @Environment(\.colorScheme) private var colorScheme

    let title: String
    let unmetRequirements: [PasswordRequirement]

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "exclamationmark.circle.fill")
                    .foregroundStyle(palette.error)

                Text(title)
                    .font(.footnote)
                    .foregroundStyle(palette.error)
            }

            VStack(alignment: .leading, spacing: 4) {
                ForEach(unmetRequirements) { requirement in
                    Text("- \(requirement.description)")
                        .font(.footnote)
                        .foregroundStyle(palette.error)
                }
            }
            .padding(.leading, 28)
        }
    }
}
