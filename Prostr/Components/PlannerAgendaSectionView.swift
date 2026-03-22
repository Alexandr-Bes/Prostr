//
//  PlannerAgendaSectionView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerAgendaSectionView: View {
    @Environment(\.appTheme) private var theme

    let cards: [PlannerContentCard]

    var body: some View {
        PlannerSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                Text("Upcoming")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)

                ForEach(Array(cards.prefix(3).enumerated()), id: \.element.id) { index, card in
                    if index > 0 {
                        Divider()
                            .overlay(theme.cardBorder)
                    }

                    agendaRow(for: card)
                }
            }
        }
    }
}

private extension PlannerAgendaSectionView {
    func agendaRow(for card: PlannerContentCard) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Text(card.platform.shortTitle)
                .font(.system(.caption, design: .rounded, weight: .bold))
                .foregroundStyle(platformTint(for: card.platform))
                .frame(width: 40, height: 40)
                .background(platformTint(for: card.platform).opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(card.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(theme.primaryText)

                Text(card.subtitle)
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
            }

            Spacer(minLength: 12)

            Text(card.state.title)
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .foregroundStyle(theme.secondaryText)
                .padding(.horizontal, 10)
                .padding(.vertical, 7)
                .background(theme.secondaryCardBackground, in: Capsule())
        }
    }

    func platformTint(for platform: PlannerPlatform) -> Color {
        switch platform {
        case .instagram:
            return Color(red: 0.85, green: 0.38, blue: 0.59)
        case .linkedin:
            return Color(red: 0.19, green: 0.47, blue: 0.82)
        case .tiktok:
            return theme.primaryText
        }
    }
}
