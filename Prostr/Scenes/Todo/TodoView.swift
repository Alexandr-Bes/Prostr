//
//  TodoView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct TodoView: View {
    @Environment(\.appTheme) private var theme

    let viewModel: TodoViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                PlannerSurfaceCard {
                    content
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
                    title: "To-do",
                    subtitle: "Keep every preparation step visible before a post goes live."
                )
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }
}

private extension TodoView {
    @ViewBuilder
    var content: some View {
        if viewModel.items.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("No to-do items yet")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)

                Text("Add items from the planner screen and they’ll show up here.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
            }
        } else {
            VStack(alignment: .leading, spacing: 18) {
                ForEach(viewModel.items) { item in
                    PlannerTodoRowView(
                        item: item,
                        trailingText: AppDateFormatter.plannerLongDateString(from: item.dueDate)
                    ) {
                        Task {
                            await viewModel.toggleTodoItem(id: item.id)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    let appCore = PreviewAppCore.make()

    NavigationStack {
        TodoView(viewModel: TodoViewModel(previewDashboard: PlannerDashboardMockData.dashboard))
    }
    .previewAppCore(appCore)
}
