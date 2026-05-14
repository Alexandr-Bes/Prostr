//
//  IdeasViewModelTests.swift
//  ProstrTests
//
//  Created by Alex on 01.04.2026.
//

import Testing
@testable import Prostr

struct IdeasViewModelTests {
    @Test
    @MainActor
    func addIdeaAppendsComposedCard() throws {
        let viewModel = IdeasViewModel(previewDashboard: PlannerDashboardMockData.dashboard)
        let composerViewModel = viewModel.makeComposerViewModel()

        composerViewModel.title = "Carousel hook"
        composerViewModel.note = "A concise breakdown of the opening hook strategy."
        composerViewModel.selectPlatform(.linkedin)

        let draft = try #require(composerViewModel.buildDraft())

        viewModel.addIdea(from: draft)

        #expect(viewModel.ideaCards.count == 3)
        #expect(viewModel.ideaCards.last?.badgeTitle == "Idea #3")
        #expect(viewModel.ideaCards.last?.platform == .linkedin)
        #expect(viewModel.ideaCards.last?.title == "Carousel hook")
    }
}
