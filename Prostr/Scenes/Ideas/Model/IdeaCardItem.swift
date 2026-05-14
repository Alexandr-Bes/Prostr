//
//  IdeaCardItem.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import Foundation

struct IdeaCardItem: Identifiable, Hashable {
    let id: String
    let badgeTitle: String
    let title: String
    let note: String
    let palette: IdeaCardPalette
    let platform: PlannerPlatform?

    init(
        idea: PlannerIdea,
        badgeTitle: String,
        palette: IdeaCardPalette,
        platform: PlannerPlatform?
    ) {
        self.id = idea.id
        self.badgeTitle = badgeTitle
        self.title = idea.title
        self.note = idea.note
        self.palette = palette
        self.platform = platform
    }

    init(draft: IdeaComposerDraft) {
        self.id = draft.id
        self.badgeTitle = draft.badgeTitle
        self.title = draft.title
        self.note = draft.note
        self.palette = draft.palette
        self.platform = draft.platform
    }
}
