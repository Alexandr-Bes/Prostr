//
//  IdeaComposerView.swift
//  Prostr
//
//  Created by Alex on 01.04.2026.
//

import Observation
import SwiftUI

struct IdeaComposerView: View {
    @FocusState private var focusedField: ComposerField?

    let viewModel: IdeaComposerViewModel
    let onClose: () -> Void
    let onSave: (IdeaComposerDraft) -> Void

    var body: some View {
        @Bindable var bindableViewModel = viewModel

        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    IdeaCardView(item: viewModel.previewItem)

                    IdeasComposerTextField(
                        title: "Title",
                        text: $bindableViewModel.title,
                        prompt: "What is the idea?",
                        axis: .horizontal,
                        errorMessage: viewModel.titleErrorMessage
                    )
                    .focused($focusedField, equals: .title)

                    IdeasComposerTextField(
                        title: "Notes",
                        text: $bindableViewModel.note,
                        prompt: "Describe the content angle",
                        axis: .vertical,
                        errorMessage: viewModel.noteErrorMessage
                    )
                    .focused($focusedField, equals: .note)

                    IdeasPlatformPicker(
                        selectedPlatform: viewModel.selectedPlatform,
                        onSelect: viewModel.selectPlatform(_:)
                    )

                    IdeasPrimaryButton(
                        title: "Create Idea",
                        systemImage: "plus",
                        action: saveTapped
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
            .scrollDismissesKeyboard(.interactively)
            .simultaneousGesture(
                TapGesture().onEnded {
                    dismissKeyboard()
                }
            )
            .background(PlannerBackgroundView().ignoresSafeArea())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "chevron.left", action: onClose)
                        .labelStyle(.iconOnly)
                        .foregroundStyle(Color(hex: "1A1A1A"))
                }

                ToolbarItem(placement: .principal) {
                    Text("Create Idea")
                        .font(.system(.headline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color(hex: "1A1A1A"))
                }
            }
        }
    }
}

private extension IdeaComposerView {
    enum ComposerField: Hashable {
        case title
        case note
    }

    func saveTapped() {
        guard let draft = viewModel.buildDraft() else {
            return
        }

        onSave(draft)
    }
}

#Preview {
    IdeaComposerView(
        viewModel: IdeaComposerViewModel(
            badgeTitle: "Idea #3",
            palette: .sage
        ),
        onClose: {},
        onSave: { _ in }
    )
    .previewAppCore()
}
