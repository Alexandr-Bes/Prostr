//
//  IdeasView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct IdeasView: View {
    @State private var composerViewModel: IdeaComposerViewModel?

    let viewModel: IdeasViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                LazyVGrid(columns: gridColumns, spacing: 16) {
                    ForEach(viewModel.ideaCards) { ideaCard in
                        IdeaCardView(item: ideaCard)
                    }
                }

                IdeasPrimaryButton(
                    title: "Add Idea",
                    systemImage: "plus",
                    action: openComposer
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            .padding(.bottom, 32)
        }
        .background(PlannerBackgroundView().ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Ideas")
                    .font(.system(.headline, design: .rounded, weight: .semibold))
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
        .fullScreenCover(item: $composerViewModel) { composerViewModel in
            IdeaComposerView(
                viewModel: composerViewModel,
                onClose: closeComposer,
                onSave: saveIdea(from:)
            )
        }
    }
}

private extension IdeasView {
    var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 16, alignment: .top),
            GridItem(.flexible(), spacing: 16, alignment: .top)
        ]
    }

    func openComposer() {
        composerViewModel = viewModel.makeComposerViewModel()
    }

    func closeComposer() {
        composerViewModel = nil
    }

    func saveIdea(from draft: IdeaComposerDraft) {
        viewModel.addIdea(from: draft)
        composerViewModel = nil
    }
}

#Preview {
    let appCore = PreviewAppCore.make()

    NavigationStack {
        IdeasView(viewModel: IdeasViewModel(previewDashboard: PlannerDashboardMockData.dashboard))
    }
    .previewAppCore(appCore)
}
