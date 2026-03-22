//
//  TodoView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct TodoView: View {
    let viewModel: TodoViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                PlannerSurfaceCard {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(viewModel.items) { item in
                            PlannerTodoChip(item: item)
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

#Preview {
    let appCore = PreviewAppCore.make()

    NavigationStack {
        TodoView(viewModel: TodoViewModel(previewDashboard: PlannerDashboardMockData.dashboard))
    }
    .previewAppCore(appCore)
}
