//
//  ProstrTests.swift
//  ProstrTests
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Testing
@testable import Prostr

struct ProstrTests {
    @Test
    @MainActor
    func deepLinkParserBuildsFeatureRoute() throws {
        let service = AppDeepLinkService()
        let url = try #require(URL(string: "prostr://feature?id=routing"))

        #expect(service.parse(url: url) == .feature(id: "routing"))
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
}
