//
//  IdeasView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct IdeasView: View {
    @Environment(\.appTheme) private var theme

    let viewModel: IdeasViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                ForEach(viewModel.ideas) { idea in
                    PlannerSurfaceCard {
                        VStack(alignment: .leading, spacing: 14) {
                            Text(idea.tag.uppercased())
                                .font(.system(.caption2, design: .rounded, weight: .bold))
                                .foregroundStyle(theme.accentTint)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(theme.accentSoft, in: Capsule())

                            Text(idea.title)
                                .font(.system(.headline, design: .rounded, weight: .bold))
                                .foregroundStyle(theme.primaryText)

                            Text(idea.note)
                                .font(.system(.subheadline, design: .rounded))
                                .foregroundStyle(theme.secondaryText)
                        }
                    }
                }
            }
            .padding(20)
            .padding(.bottom, 32)
        }
        .background(PlannerBackgroundView().ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PlannerScreenHeaderView(
                    title: "Ideas",
                    subtitle: "Capture rough concepts now, then shape them into a content plan later."
                )
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }
}

#Preview {
    let appCore = PreviewAppCore.make()

    NavigationStack {
        IdeasView(viewModel: IdeasViewModel(previewDashboard: PlannerDashboardMockData.dashboard))
    }
    .previewAppCore(appCore)
}
