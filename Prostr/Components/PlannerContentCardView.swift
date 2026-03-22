//
//  PlannerContentCardView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct PlannerContentCardView: View {
    @Environment(\.appTheme) private var theme

    let card: PlannerContentCard

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    statusBadge

                    Spacer(minLength: 8)

                    Text(AppDateFormatter.plannerCardDateString(from: card.effectiveDisplayDate))
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(card.title)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)

                    Text(card.subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(theme.secondaryText)
                }

                Spacer(minLength: 12)

                platformBadge
                footerBadge
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            preview
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 212, alignment: .leading)
        .background(backgroundGradient, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(theme.cardBorder.opacity(0.85), lineWidth: 1)
        )
        .shadow(color: theme.cardShadow, radius: 16, y: 10)
    }
}

private extension PlannerContentCardView {
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [palette.backgroundTop, palette.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var statusBadge: some View {
        Label {
            Text(card.state.title)
                .font(.system(.caption2, design: .rounded, weight: .bold))
                .foregroundStyle(palette.accent)
                .lineLimit(1)
        } icon: {
            Image(systemName: statusSymbolName)
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(palette.accent)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(palette.chipBackground, in: Capsule())
    }

    var platformBadge: some View {
        HStack(spacing: 6) {
            Circle()
                .fill(palette.accent)
                .frame(width: 7, height: 7)

            Text(card.platform.shortTitle)
                .font(.system(.caption, design: .rounded, weight: .bold))
        }
        .foregroundStyle(theme.primaryText)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(.white.opacity(0.68), in: Capsule())
    }

    var footerBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: card.imageAssetName == nil ? "square.stack.3d.up" : "photo")
                .font(.system(size: 11, weight: .bold))

            Text(card.imageAssetName == nil ? "Media pending" : "Image attached")
                .font(.system(.caption, design: .rounded, weight: .semibold))
        }
        .foregroundStyle(theme.secondaryText)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(.white.opacity(0.58), in: Capsule())
    }

    var statusSymbolName: String {
        switch card.state {
        case .draft:
            return "pencil"
        case .planned:
            return "calendar"
        case .scheduled:
            return "clock"
        }
    }

    @ViewBuilder
    var preview: some View {
        if let imageAssetName = card.imageAssetName {
            imagePreview(imageAssetName)
        } else {
            placeholderPreview
        }
    }

    func imagePreview(_ imageAssetName: String) -> some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(palette.accent.opacity(0.14))
                .frame(width: 116, height: 160)
                .offset(x: -10, y: 8)

            Image(imageAssetName)
                .resizable()
                .scaledToFill()
                .frame(width: 116, height: 160)
                .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.white.opacity(0.30), lineWidth: 1)
                )
                .overlay(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.14)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
                )

            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.86))
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "photo.stack")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(palette.accent)
                )
                .offset(x: 8, y: 8)
        }
        .frame(width: 126, height: 172)
    }

    var placeholderPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.42))
                .frame(width: 116, height: 160)
                .offset(x: -10, y: 8)

            layeredPreview
        }
        .frame(width: 126, height: 172)
    }

    var layeredPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.44))
                .frame(width: 92, height: 130)
                .rotationEffect(.degrees(-14))
                .offset(x: -10, y: 8)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.58))
                .frame(width: 92, height: 130)
                .rotationEffect(.degrees(-4))
                .offset(x: 4, y: 2)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.white.opacity(0.94))
                .frame(width: 92, height: 130)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(palette.accent)
                            .frame(height: 14)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.secondaryCardBackground)
                            .frame(height: 10)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.secondaryCardBackground)
                            .frame(height: 10)

                        Spacer(minLength: 0)

                        RoundedRectangle(cornerRadius: 14)
                            .fill(palette.chipBackground)
                            .frame(width: 44, height: 24)
                    }
                    .padding(12)
                )
        }
    }

    var palette: CardPalette {
        switch card.state {
        case .planned:
            return CardPalette(
                backgroundTop: Color(red: 0.98, green: 0.95, blue: 0.92),
                backgroundBottom: Color(red: 0.95, green: 0.89, blue: 0.82),
                accent: Color(red: 0.67, green: 0.40, blue: 0.23),
                chipBackground: Color(red: 0.98, green: 0.88, blue: 0.78)
            )
        case .scheduled:
            return CardPalette(
                backgroundTop: Color(red: 0.92, green: 0.96, blue: 0.91),
                backgroundBottom: Color(red: 0.86, green: 0.91, blue: 0.85),
                accent: Color(red: 0.28, green: 0.48, blue: 0.33),
                chipBackground: Color(red: 0.81, green: 0.91, blue: 0.80)
            )
        case .draft:
            return CardPalette(
                backgroundTop: Color(red: 0.99, green: 0.93, blue: 0.89),
                backgroundBottom: Color(red: 0.97, green: 0.86, blue: 0.79),
                accent: Color(red: 0.77, green: 0.49, blue: 0.30),
                chipBackground: Color(red: 0.99, green: 0.86, blue: 0.76)
            )
        }
    }
}

private struct CardPalette {
    let backgroundTop: Color
    let backgroundBottom: Color
    let accent: Color
    let chipBackground: Color
}
