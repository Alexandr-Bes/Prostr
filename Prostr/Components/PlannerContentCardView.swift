//
//  PlannerContentCardView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerContentCardView: View {
    let card: PlannerContentCard

    private let cardHeight: CGFloat = 228
    private let cornerRadius: CGFloat = 16
    private let mediaWidthRatio: CGFloat = 0.27
    private let minimumMediaWidth: CGFloat = 92

    var body: some View {
        GeometryReader { geometry in
            let mediaWidth = max(geometry.size.width * mediaWidthRatio, minimumMediaWidth)

            HStack(spacing: 0) {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)

                mediaSection
                    .frame(width: mediaWidth)
                    .frame(maxHeight: .infinity)
            }
            .background(backgroundGradient)
            .clipShape(cardShape)
            .overlay {
                cardShape
                    .strokeBorder(palette.borderColor, lineWidth: 1)
            }
            .shadow(color: palette.shadowColor, radius: 20, x: 0, y: 12)
        }
        .frame(height: cardHeight)
    }
}

private extension PlannerContentCardView {
    var content: some View {
        VStack(alignment: .leading, spacing: 18) {
            headerRow

            VStack(alignment: .leading, spacing: 10) {
                Text(card.title)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(palette.primaryTextColor)
                    .lineLimit(1)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(card.subtitle)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.secondaryTextColor)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .layoutPriority(1)

            Spacer(minLength: 12)

            footerRow
        }
    }

    var headerRow: some View {
        HStack(alignment: .center, spacing: 12) {
            statusBadge

            Spacer(minLength: 8)

            statusDateLabel
        }
    }

    var footerRow: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if let avatarAssetName = card.platform.avatarAssetName {
                Image(avatarAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .accessibilityHidden(true)
            }

            Spacer(minLength: 0)

            if let tag = normalizedTag {
                Text(tag)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(palette.tagTextColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(palette.tagBackgroundColor, in: Capsule())
                    .lineLimit(1)
            }
        }
    }

    var statusBadge: some View {
        HStack(spacing: 4) {
            Image(card.state.iconAssetName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
                .accessibilityHidden(true)

            Text(card.state.title)
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .lineLimit(1)
        }
        .foregroundStyle(palette.statusTextColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(palette.statusBackgroundColor, in: Capsule())
    }

    @ViewBuilder
    var statusDateLabel: some View {
        switch card.state {
        case .draft:
            EmptyView()

        case .planned:
            Text(AppDateFormatter.plannerCardDateString(from: card.effectiveDisplayDate))
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(palette.metaTextColor)
                .lineLimit(1)

        case .scheduled:
            HStack(spacing: 6) {
                Image("scheduledDateIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)

                Text(AppDateFormatter.plannerCardDateString(from: card.effectiveDisplayDate))
                    .lineLimit(1)
            }
            .font(.system(size: 12, weight: .medium, design: .rounded))
            .foregroundStyle(palette.metaTextColor)
        }
    }

    var mediaSection: some View {
        Group {
            if let imageAssetName = card.imageAssetName {
                Image(imageAssetName)
                    .resizable()
                    .scaledToFill()
            } else {
                placeholderMedia
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
        .accessibilityHidden(true)
    }

    var placeholderMedia: some View {
        ZStack {
            LinearGradient(
                colors: [
                    palette.placeholderTopColor,
                    palette.placeholderBottomColor
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.44))
                    .frame(width: 52, height: 80)
                    .offset(x: -12, y: -8)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.66))
                    .frame(width: 58, height: 88)
                    .offset(x: -2, y: 4)

                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white.opacity(0.88))
                    .frame(width: 64, height: 96)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundStyle(palette.metaTextColor.opacity(0.65))
                    }
                    .offset(x: 8, y: 14)
            }
        }
    }

    var backgroundGradient: some ShapeStyle {
        LinearGradient(
            colors: [palette.gradientStartColor, palette.gradientEndColor],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var normalizedTag: String? {
        guard let tag = card.tag?.trimmingCharacters(in: .whitespacesAndNewlines), !tag.isEmpty else {
            return nil
        }

        return tag
    }

    var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
    }

    var palette: PlannerContentCardPalette {
        switch card.state {
        case .draft:
            return .draft
        case .planned:
            return .planned
        case .scheduled:
            return .scheduled
        }
    }
}

private struct PlannerContentCardPalette {
    let gradientStartColor: Color
    let gradientEndColor: Color
    let statusBackgroundColor: Color
    let statusTextColor: Color
    let primaryTextColor: Color
    let secondaryTextColor: Color
    let metaTextColor: Color
    let tagBackgroundColor: Color
    let tagTextColor: Color
    let placeholderTopColor: Color
    let placeholderBottomColor: Color
    let borderColor: Color
    let shadowColor: Color

    static let draft = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "FBFBFE"),
        gradientEndColor: Color(hex: "EDEFFF"),
        statusBackgroundColor: Color(hex: "A9B0D9"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "4F4B54"),
        metaTextColor: Color(hex: "6B7290"),
        tagBackgroundColor: Color(hex: "DEE3FF"),
        tagTextColor: Color(hex: "48537A"),
        placeholderTopColor: Color(hex: "F0F2FF"),
        placeholderBottomColor: Color(hex: "DCE0FF"),
        borderColor: Color.white.opacity(0.75),
        shadowColor: Color(hex: "20213D", opacity: 0.10)
    )

    static let scheduled = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "D4EDFF"),
        gradientEndColor: Color(hex: "F1F9FF"),
        statusBackgroundColor: Color(hex: "5D98C2"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "48515B"),
        metaTextColor: Color(hex: "557B99"),
        tagBackgroundColor: Color(hex: "D6EEF9"),
        tagTextColor: Color(hex: "315A71"),
        placeholderTopColor: Color(hex: "E5F5FF"),
        placeholderBottomColor: Color(hex: "C9E9FF"),
        borderColor: Color.white.opacity(0.72),
        shadowColor: Color(hex: "1F5E84", opacity: 0.10)
    )

    static let planned = PlannerContentCardPalette(
        gradientStartColor: Color(hex: "C9EFF1"),
        gradientEndColor: Color(hex: "F3FEFF"),
        statusBackgroundColor: Color(hex: "6A9B97"),
        statusTextColor: .white,
        primaryTextColor: Color(hex: "1F1C1B"),
        secondaryTextColor: Color(hex: "475453"),
        metaTextColor: Color(hex: "568988"),
        tagBackgroundColor: Color(hex: "C9F0C9"),
        tagTextColor: Color(hex: "2E6C49"),
        placeholderTopColor: Color(hex: "DDF8F8"),
        placeholderBottomColor: Color(hex: "C5ECEF"),
        borderColor: Color.white.opacity(0.72),
        shadowColor: Color(hex: "286467", opacity: 0.10)
    )
}

private extension PlannerCardState {
    var iconAssetName: String {
        switch self {
        case .draft:
            return "draftIcon"
        case .planned:
            return "plannedIcon"
        case .scheduled:
            return "scheduledIcon"
        }
    }
}
