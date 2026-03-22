//
//  PlannerScreenHeaderView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerScreenHeaderView: View {
    @Environment(\.appTheme) private var theme

    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 2) {
            Text(title)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(theme.primaryText)
                .lineLimit(1)

            Text(subtitle)
                .font(.system(.caption, design: .rounded, weight: .medium))
                .foregroundStyle(theme.secondaryText)
                .lineLimit(1)
        }
        .multilineTextAlignment(.center)
    }
}
