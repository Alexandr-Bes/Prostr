//
//  PlannerTodoRowView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerTodoRowView: View {
    @Environment(\.appTheme) private var theme

    let item: PlannerTodoItem
    let trailingText: String?
    let onToggle: () -> Void

    init(
        item: PlannerTodoItem,
        trailingText: String? = nil,
        onToggle: @escaping () -> Void
    ) {
        self.item = item
        self.trailingText = trailingText
        self.onToggle = onToggle
    }

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: item.isCompleted ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(checkboxColor)

                Text(item.title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(titleColor)
                    .strikethrough(item.isCompleted, color: titleColor.opacity(0.75))
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if let trailingText, !trailingText.isEmpty {
                    Text(trailingText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(theme.secondaryText)
                        .lineLimit(1)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private extension PlannerTodoRowView {
    var checkboxColor: Color {
        item.isCompleted ? theme.accentTint : theme.tertiaryText.opacity(0.7)
    }

    var titleColor: Color {
        item.isCompleted ? theme.secondaryText : theme.primaryText
    }
}
