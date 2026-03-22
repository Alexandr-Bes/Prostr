//
//  PlannerContentCardView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct PlannerContentCardView: View {
    let card: PlannerContentCard

    var body: some View {
        HStack(alignment: .top, spacing: 18) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 8) {
                    statusBadge

                    Spacer(minLength: 8)

                    Text(AppDateFormatter.plannerCardDateString(from: card.effectiveDisplayDate))
                        .font(.system(.caption2, design: .rounded, weight: .bold))
                        .foregroundStyle(palette.primaryText)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text(card.title)
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(palette.primaryText)

                    Text(card.subtitle)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(palette.secondaryText)
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
                .stroke(palette.border, lineWidth: 1)
        )
        .shadow(color: palette.shadow, radius: 16, y: 10)
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
        .foregroundStyle(palette.primaryText)
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(palette.softSurface, in: Capsule())
    }

    var footerBadge: some View {
        HStack(spacing: 8) {
            Image(systemName: card.imageAssetName == nil ? "square.stack.3d.up" : "photo")
                .font(.system(size: 11, weight: .bold))

            Text(card.imageAssetName == nil ? "Media pending" : "Image attached")
                .font(.system(.caption, design: .rounded, weight: .semibold))
        }
        .foregroundStyle(palette.secondaryText)
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(palette.softSurface.opacity(0.92), in: Capsule())
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
                        .stroke(Color.white.opacity(0.30), lineWidth: 1)
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
                .fill(palette.softSurface)
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
                .fill(palette.softSurface.opacity(0.52))
                .frame(width: 116, height: 160)
                .offset(x: -10, y: 8)

            layeredPreview
        }
        .frame(width: 126, height: 172)
    }

    var layeredPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.44))
                .frame(width: 92, height: 130)
                .rotationEffect(.degrees(-14))
                .offset(x: -10, y: 8)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.58))
                .frame(width: 92, height: 130)
                .rotationEffect(.degrees(-4))
                .offset(x: 4, y: 2)

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.94))
                .frame(width: 92, height: 130)
                .overlay(
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(palette.accent)
                            .frame(height: 14)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.72))
                            .frame(height: 10)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.72))
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
                backgroundTop: Color(hex: "C9EFF1"),
                backgroundBottom: Color(hex: "F3FEFF"),
                accent: Color(hex: "4B8F90"),
                chipBackground: Color.white.opacity(0.72),
                primaryText: Color(hex: "1A2525"),
                secondaryText: Color(hex: "536564"),
                border: Color.black.opacity(0.05),
                shadow: Color.black.opacity(0.08)
            )
        case .scheduled:
            return CardPalette(
                backgroundTop: Color(hex: "D4EDFF"),
                backgroundBottom: Color(hex: "F1F9FF"),
                accent: Color(hex: "4C87B1"),
                chipBackground: Color.white.opacity(0.72),
                primaryText: Color(hex: "1C242D"),
                secondaryText: Color(hex: "566370"),
                border: Color.black.opacity(0.05),
                shadow: Color.black.opacity(0.08)
            )
        case .draft:
            return CardPalette(
                backgroundTop: Color(hex: "FBFBFE"),
                backgroundBottom: Color(hex: "EDEFFF"),
                accent: Color(hex: "7A82C6"),
                chipBackground: Color.white.opacity(0.72),
                primaryText: Color(hex: "232536"),
                secondaryText: Color(hex: "61657C"),
                border: Color.black.opacity(0.05),
                shadow: Color.black.opacity(0.08)
            )
        }
    }
}

private struct CardPalette {
    let backgroundTop: Color
    let backgroundBottom: Color
    let accent: Color
    let chipBackground: Color
    let primaryText: Color
    let secondaryText: Color
    let border: Color
    let shadow: Color

    var softSurface: Color {
        chipBackground
    }
}
