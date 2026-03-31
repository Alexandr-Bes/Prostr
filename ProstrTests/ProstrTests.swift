//
//  ProstrTests.swift
//  ProstrTests
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Testing
@testable import Prostr

struct ProstrTests {
    @Test
    func hexColorComponentsParseHashPrefixedHex() throws {
        let components = try #require(HexColorComponents(hex: "#FAFAFC"))

        #expect(abs(components.red - (250.0 / 255.0)) < 0.0001)
        #expect(abs(components.green - (250.0 / 255.0)) < 0.0001)
        #expect(abs(components.blue - (252.0 / 255.0)) < 0.0001)
        #expect(abs(components.alpha - 1.0) < 0.0001)
    }

    @Test
    func hexColorComponentsParseBareHex() throws {
        let components = try #require(HexColorComponents(hex: "FAFAFC"))

        #expect(abs(components.red - (250.0 / 255.0)) < 0.0001)
        #expect(abs(components.green - (250.0 / 255.0)) < 0.0001)
        #expect(abs(components.blue - (252.0 / 255.0)) < 0.0001)
        #expect(abs(components.alpha - 1.0) < 0.0001)
    }

    @Test
    @MainActor
    func deepLinkParserBuildsFeatureRoute() throws {
        let service = AppDeepLinkService()
        let url = try #require(URL(string: "prostr://feature?id=routing"))

        #expect(service.parse(url: url) == .feature(id: "routing"))
    }

    @Test
    @MainActor
    func deepLinkParserBuildsCalendarDateRoute() throws {
        let service = AppDeepLinkService()
        let url = try #require(URL(string: "prostr://calendar?date=2026-03-22"))
        let expectedDate = try #require(AppDateFormatter.plannerDeepLinkDate(from: "2026-03-22"))

        #expect(service.parse(url: url) == .calendar(date: expectedDate))
    }

    @Test
    @MainActor
    func themeServicePersistsPreferredMode() {
        let storage = InMemoryStorageAdapter()
        let service = ThemeService(localStorage: storage)

        #expect(service.loadThemeMode() == .system)

        service.saveThemeMode(.dark)

        #expect(service.loadThemeMode() == .dark)
    }

    @Test
    func deepLinkRouteRestoresFromStorageValue() {
        let route = DeepLinkRoute.feature(id: "persistence")

        #expect(DeepLinkRoute(storageValue: route.storageValue) == route)
    }

    @Test
    func deepLinkRouteRestoresCalendarDateFromStorageValue() throws {
        let date = try #require(AppDateFormatter.plannerDeepLinkDate(from: "2026-03-22"))
        let route = DeepLinkRoute.calendar(date: date)

        #expect(DeepLinkRoute(storageValue: route.storageValue) == route)
    }

    @Test
    func plannerContentCardUpdateUsesDraftRules() {
        let originalCard = PlannerDashboardMockData.dashboard.cards[0]
        let imageData = Data([0x01, 0x02, 0x03])

        let updatedCard = originalCard.updating(
            title: "Updated draft",
            bodyText: "A longer edited description for the draft post body.",
            state: .draft,
            imageAssetName: "sunsetRome",
            imageData: imageData,
            detailTags: ["travel", "rome"],
            hashtags: ["#travel", "#rome"]
        )

        #expect(updatedCard.state == .draft)
        #expect(updatedCard.postDate == nil)
        #expect(updatedCard.imageAssetName == nil)
        #expect(updatedCard.imageData == imageData)
        #expect(updatedCard.tag == "rome")
        #expect(updatedCard.subtitle == "A longer edited description for the draft post body.")
    }

    @Test
    func plannerContentCardUpdateRestoresPostingDateForNonDraftStates() throws {
        let draftCard = try #require(
            PlannerDashboardMockData.dashboard.cards.first(where: { $0.state == .draft })
        )

        let updatedCard = draftCard.updating(
            title: draftCard.title,
            bodyText: draftCard.bodyText,
            state: .planned,
            imageAssetName: draftCard.imageAssetName,
            imageData: nil,
            detailTags: draftCard.detailTags,
            hashtags: draftCard.hashtags
        )

        #expect(updatedCard.state == .planned)
        #expect(updatedCard.postDate == draftCard.createdAt)
    }

    @Test
    @MainActor
    func plannerContentCardStoreSupportsCRUD() async throws {
        let swiftData = SwiftDataService(
            containerProvider: ModelContainerProvider(isStoredInMemoryOnly: true)
        )
        let store = SwiftDataPlannerContentCardStore(swiftData: swiftData)
        let scheduledDate = try #require(AppDateFormatter.plannerDeepLinkDate(from: "2026-03-22"))

        let createdCard = PlannerContentCard.makeDraft(postDate: scheduledDate).updating(
            title: "Rome draft",
            bodyText: "A brand new post created from the planner.",
            state: .planned,
            imageAssetName: nil,
            imageData: nil,
            detailTags: ["travel"],
            hashtags: ["#rome"],
            fallbackPostDate: scheduledDate
        )

        try await store.createPost(createdCard)

        let fetchedCard = try #require(try await store.fetchPost(id: createdCard.id))
        #expect(fetchedCard.title == "Rome draft")
        #expect(fetchedCard.state == .planned)

        let updatedCard = createdCard.updating(
            title: "Rome update",
            bodyText: "An updated planner post body.",
            state: .scheduled,
            imageAssetName: nil,
            imageData: nil,
            detailTags: ["travel", "rome"],
            hashtags: ["#rome", "#italy"],
            fallbackPostDate: scheduledDate
        )

        try await store.updatePost(updatedCard)

        let reloadedCard = try #require(try await store.fetchPost(id: updatedCard.id))
        #expect(reloadedCard.title == "Rome update")
        #expect(reloadedCard.state == .scheduled)
        #expect(reloadedCard.detailTags == ["travel", "rome"])

        try await store.deletePost(id: updatedCard.id)

        #expect(try await store.fetchPost(id: updatedCard.id) == nil)
    }

    @Test
    @MainActor
    func plannerDashboardRepositoryPersistsCreatedPostsInLocalStore() async throws {
        let swiftData = SwiftDataService(
            containerProvider: ModelContainerProvider(isStoredInMemoryOnly: true)
        )
        let store = SwiftDataPlannerContentCardStore(swiftData: swiftData)
        let repository = PlannerDashboardRepository(
            service: MockPlannerDashboardService(),
            contentCardStore: store
        )

        _ = try await repository.fetchDashboard()

        let selectedDate = try #require(AppDateFormatter.plannerDeepLinkDate(from: "2026-03-24"))
        let localPost = PlannerContentCard.makeDraft(postDate: selectedDate).updating(
            title: "Local planner post",
            bodyText: "Stored locally and merged back into the dashboard.",
            state: .planned,
            imageAssetName: nil,
            imageData: nil,
            detailTags: ["travel"],
            hashtags: ["#local"],
            fallbackPostDate: selectedDate
        )

        _ = try await repository.createContentCard(localPost)

        let freshRepository = PlannerDashboardRepository(
            service: MockPlannerDashboardService(),
            contentCardStore: store
        )
        let reloadedDashboard = try await freshRepository.fetchDashboard()

        #expect(reloadedDashboard.cards.contains(where: { $0.id == localPost.id }))
    }
}
