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
}
