//
//  IdeaCardView.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import SwiftUI

struct IdeaCardView: View {
    let item: IdeaCardItem

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            badgeView

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 14, weight: .semibold, design: .rounded))
                    .foregroundStyle(primaryTextColor)

                Text(item.note)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(primaryTextColor)
                    .lineLimit(4)
            }

            Spacer(minLength: 0)

            if let platform = item.platform {
                footerView(for: platform)
            }
        }
        .padding(10)
        .frame(maxWidth: .infinity, minHeight: 172, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(item.palette.backgroundColor)
        )
        .overlay(alignment: .bottomTrailing) {
            Circle()
                .fill(item.palette.cornerAccentColor)
                .frame(width: 58, height: 58)
                .offset(x: 20, y: 20)
                .accessibilityHidden(true)
        }
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

private extension IdeaCardView {
    var primaryTextColor: Color {
        Color(hex: "1A1A1A")
    }

    var badgeView: some View {
        Text(item.badgeTitle)
            .font(.system(size: 10, weight: .semibold, design: .rounded))
            .foregroundStyle(primaryTextColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(hex: "BEC7CE"), in: Capsule())
    }

    func footerView(for platform: PlannerPlatform) -> some View {
        HStack(spacing: 4) {
            mediaBadgeView
            platformBadgeView(for: platform)
        }
    }

    var mediaBadgeView: some View {
        RoundedRectangle(cornerRadius: 8, style: .continuous)
            .fill(.white)
            .frame(width: 30, height: 30)
            .overlay {
                Image(systemName: "photo")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color(hex: "2883C9"))
            }
    }

    func platformBadgeView(for platform: PlannerPlatform) -> some View {
        ZStack(alignment: .bottomTrailing) {
            avatarView(for: platform)

            Circle()
                .fill(platformBadgeColor(for: platform))
                .frame(width: 14, height: 14)
                .overlay {
                    Image(systemName: platformBadgeIcon(for: platform))
                        .font(.system(size: 7, weight: .bold))
                        .foregroundStyle(.white)
                }
        }
        .frame(width: 30, height: 30)
    }

    func avatarView(for platform: PlannerPlatform) -> some View {
        Group {
            if let avatarAssetName = platform.avatarAssetName {
                Image(avatarAssetName)
                    .resizable()
                    .scaledToFill()
            } else {
                Circle()
                    .fill(Color(hex: "BEC7CE"))
            }
        }
        .frame(width: 26, height: 26)
        .clipShape(Circle())
        .overlay(
            Circle()
                .stroke(.white, lineWidth: 1)
        )
    }

    func platformBadgeColor(for platform: PlannerPlatform) -> Color {
        switch platform {
        case .instagram:
            return Color(hex: "E1306C")
        case .linkedin:
            return Color(hex: "0A66C2")
        case .tiktok:
            return Color.black
        }
    }

    func platformBadgeIcon(for platform: PlannerPlatform) -> String {
        switch platform {
        case .instagram:
            return "camera.fill"
        case .linkedin:
            return "briefcase.fill"
        case .tiktok:
            return "music.note"
        }
    }
}
