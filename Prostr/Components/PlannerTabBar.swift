//
//  PlannerTabBar.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerTabBar: View {
    @Environment(\.appTheme) private var theme

    let selection: AppTab
    let onSelect: (AppTab) -> Void

    var body: some View {
        HStack(spacing: 10) {
            ForEach(AppTab.allCases) { tab in
                tabButton(for: tab)
            }
        }
        .padding(10)
        .background(theme.tabBarBackground.opacity(0.96), in: RoundedRectangle(cornerRadius: 30, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .stroke(theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: theme.cardShadow, radius: 18, y: 10)
        .padding(.horizontal, 20)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
}

private extension PlannerTabBar {
    func tabButton(for tab: AppTab) -> some View {
        let isSelected = selection == tab

        return Button {
            onSelect(tab)
        } label: {
            HStack(spacing: 8) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 15, weight: .semibold))

                if isSelected {
                    Text(tab.title)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .transition(.opacity.combined(with: .move(edge: .trailing)))
                }
            }
            .foregroundStyle(isSelected ? theme.inverseText : theme.secondaryText)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
            .background(
                isSelected ? theme.tabBarActiveBackground : theme.tabBarInactiveBackground.opacity(0.48),
                in: RoundedRectangle(cornerRadius: 22, style: .continuous)
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(tab.title)
    }
}
