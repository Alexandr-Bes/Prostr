//
//  IdeaComposerDraft.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import Foundation

struct IdeaComposerDraft: Hashable {
    let id: String
    let badgeTitle: String
    let title: String
    let note: String
    let palette: IdeaCardPalette
    let platform: PlannerPlatform?
}
