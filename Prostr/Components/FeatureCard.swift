//
//  FeatureCard.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct FeatureCard: View {
    @Environment(\.appTheme) private var theme

    let feature: AppFeature

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: feature.symbolName)
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(iconGradient, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

                VStack(alignment: .leading, spacing: 6) {
                    Text(feature.title)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)

                    Text(feature.subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(theme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 8)

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(theme.secondaryText)
                    .padding(10)
                    .background(theme.overlaySurface, in: Circle())
            }

            HStack(spacing: 10) {
                Label("Repository driven", systemImage: "tray.full.fill")
                Label("Deep-link ready", systemImage: "point.3.connected.trianglepath.dotted")
            }
            .font(.system(.caption, design: .rounded, weight: .semibold))
            .foregroundStyle(theme.secondaryText)
        }
        .padding(20)
        .background(theme.cardBackground, in: RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .strokeBorder(theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: theme.cardShadow, radius: 18, y: 10)
    }
}

private extension FeatureCard {
    var iconGradient: LinearGradient {
        switch feature.accentStyle {
        case .ocean:
            return LinearGradient(colors: [.blue, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .forest:
            return LinearGradient(colors: [.green, .mint], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .sunset:
            return LinearGradient(colors: [.orange, .pink], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
