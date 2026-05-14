//
//  IdeasViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class IdeasViewModel {
    private let plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    private var hasLoaded = false

    private(set) var ideaCards: [IdeaCardItem] = []
    private var nextIdeaNumber = 1

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        self.plannerDashboardRepository = plannerDashboardRepository
    }

    init(previewDashboard: PlannerDashboard) {
        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.ideaCards = Self.makeIdeaCards(from: previewDashboard.ideas)
        self.nextIdeaNumber = self.ideaCards.count + 1
        self.hasLoaded = true
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }

        do {
            let ideas = try await plannerDashboardRepository.fetchDashboard().ideas
            ideaCards = Self.makeIdeaCards(from: ideas)
            nextIdeaNumber = ideaCards.count + 1
            hasLoaded = true
        } catch {
            Log.error(error)
        }
    }

    func makeComposerViewModel() -> IdeaComposerViewModel {
        IdeaComposerViewModel(
            badgeTitle: "Idea #\(nextIdeaNumber)",
            palette: IdeaCardPalette.palette(for: nextIdeaNumber - 1)
        )
    }

    func addIdea(from draft: IdeaComposerDraft) {
        ideaCards.append(IdeaCardItem(draft: draft))
        nextIdeaNumber += 1
    }
}

private extension IdeasViewModel {
    static func makeIdeaCards(from ideas: [PlannerIdea]) -> [IdeaCardItem] {
        ideas.enumerated().map { index, idea in
            IdeaCardItem(
                idea: idea,
                badgeTitle: "Idea #\(index + 1)",
                palette: IdeaCardPalette.palette(for: index),
                platform: index == 1 ? .instagram : nil
            )
        }
    }
}
