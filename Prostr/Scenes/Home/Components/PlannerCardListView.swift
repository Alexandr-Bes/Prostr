//
//  PlannerCardListView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 24.03.2026.
//

import SwiftUI

struct PlannerCardListView: View {
    @Environment(\.appTheme) private var theme

    @Binding var selectedFilter: PlannerCardFilter

    let sections: [PlannerCardListSection]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            PlannerCardFilterBarView(selection: $selectedFilter)

            if sections.isEmpty {
                emptyState
            } else {
                VStack(alignment: .leading, spacing: 22) {
                    ForEach(sections) { section in
                        sectionView(for: section)
                    }
                }
            }
        }
    }
}

private extension PlannerCardListView {
    func sectionView(for section: PlannerCardListSection) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            if let title = section.title {
                Text(title)
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)
            }

            VStack(alignment: .leading, spacing: 16) {
                ForEach(section.cards) { card in
                    PlannerContentCardView(card: card)
                }
            }
        }
    }

    var emptyState: some View {
        PlannerSurfaceCard(backgroundColor: theme.cardBackground) {
            VStack(alignment: .leading, spacing: 8) {
                Text("No posts yet")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)

                Text("Try another filter or add a new content idea to start building your plan.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
            }
        }
    }
}

#Preview {
    PlannerCardListView(selectedFilter: .constant(.all), sections: [])
}
