//
//  PlannerTodoChip.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct PlannerTodoChip: View {
    @Environment(\.appTheme) private var theme

    let item: PlannerTodoItem

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(iconColor)
                .frame(width: 28, height: 28)
                .background(iconBackgroundColor, in: Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(theme.primaryText)

                if item.state != .default {
                    Text(item.state.title)
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(theme.secondaryText)
                }
            }

            Spacer(minLength: 12)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(theme.tertiaryText)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private extension PlannerTodoChip {
    var backgroundColor: Color {
        switch item.state {
        case .default:
            return theme.secondaryCardBackground
        case .checked:
            return theme.successTint.opacity(0.14)
        case .today:
            return theme.accentSoft
        case .overdue:
            return theme.dangerTint.opacity(0.12)
        }
    }

    var iconBackgroundColor: Color {
        switch item.state {
        case .default:
            return theme.cardBackground
        case .checked:
            return theme.successTint.opacity(0.14)
        case .today:
            return theme.accentSoft
        case .overdue:
            return theme.dangerTint.opacity(0.12)
        }
    }

    var iconColor: Color {
        switch item.state {
        case .default:
            return theme.secondaryText
        case .checked:
            return theme.successTint
        case .today:
            return theme.accentTint
        case .overdue:
            return theme.dangerTint
        }
    }

    var iconName: String {
        switch item.state {
        case .default:
            return "circle"
        case .checked:
            return "checkmark.circle.fill"
        case .today:
            return "clock.fill"
        case .overdue:
            return "exclamationmark.circle.fill"
        }
    }
}
