//
//  PlannerTodoSectionView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerTodoSectionView: View {
    @Environment(\.appTheme) private var theme

    let items: [PlannerTodoItem]
    let onSeeAll: () -> Void
    let onAdd: () -> Void

    init(
        items: [PlannerTodoItem],
        onSeeAll: @escaping () -> Void,
        onAdd: @escaping () -> Void = {}
    ) {
        self.items = items
        self.onSeeAll = onSeeAll
        self.onAdd = onAdd
    }

    var body: some View {
        PlannerSurfaceCard {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("To-do list")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)

                    Spacer()

                    Button("See all", action: onSeeAll)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(theme.accentTint)
                }

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(items.prefix(4)) { item in
                        PlannerTodoChip(item: item)
                    }
                }

                Button(action: onAdd) {
                    HStack(spacing: 10) {
                        Image(systemName: "plus")
                            .font(.system(size: 12, weight: .bold))

                        Text("Add To-do List")
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    }
                    .foregroundStyle(theme.secondaryText)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(theme.secondaryCardBackground.opacity(0.75), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
    }
}
