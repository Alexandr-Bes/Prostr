//
//  IdeaComposerViewModel.swift
//  Prostr
//
//  Created by Alex on 01.04.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class IdeaComposerViewModel: Identifiable {
    let id = UUID()

    private let badgeTitle: String
    private let palette: IdeaCardPalette

    var title = ""
    var note = ""
    var selectedPlatform: PlannerPlatform?

    private(set) var isValidationVisible = false

    init(
        badgeTitle: String,
        palette: IdeaCardPalette
    ) {
        self.badgeTitle = badgeTitle
        self.palette = palette
    }

    var titleErrorMessage: String? {
        guard isValidationVisible, trimmedTitle.isEmpty else {
            return nil
        }

        return "Enter an idea title."
    }

    var noteErrorMessage: String? {
        guard isValidationVisible, trimmedNote.isEmpty else {
            return nil
        }

        return "Add a short description."
    }

    var previewItem: IdeaCardItem {
        IdeaCardItem(
            draft: IdeaComposerDraft(
                id: id.uuidString,
                badgeTitle: badgeTitle,
                title: trimmedTitle.isEmpty ? "Your idea title" : trimmedTitle,
                note: trimmedNote.isEmpty ? "A short note that explains the content angle for this idea." : trimmedNote,
                palette: palette,
                platform: selectedPlatform
            )
        )
    }

    func selectPlatform(_ platform: PlannerPlatform?) {
        selectedPlatform = platform
    }

    func buildDraft() -> IdeaComposerDraft? {
        isValidationVisible = true

        guard titleErrorMessage == nil, noteErrorMessage == nil else {
            return nil
        }

        return IdeaComposerDraft(
            id: UUID().uuidString,
            badgeTitle: badgeTitle,
            title: trimmedTitle,
            note: trimmedNote,
            palette: palette,
            platform: selectedPlatform
        )
    }
}

private extension IdeaComposerViewModel {
    var trimmedTitle: String {
        title.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNote: String {
        note.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
