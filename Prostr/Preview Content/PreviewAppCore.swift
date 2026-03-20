//
//  PreviewAppCore.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

@MainActor
enum PreviewAppCore {
    static let shared: AppCore = {
        let localStorage = InMemoryStorageAdapter()
        let swiftDataService = SwiftDataService(containerProvider: ModelContainerProvider(isStoredInMemoryOnly: true))
        let themeService = ThemeService(localStorage: localStorage)
        let deepLinkService = AppDeepLinkService()
        let deepLinkStore = SwiftDataDeepLinkHistoryStore(swiftData: swiftDataService)

        let services = AppServices(
            swiftDataService: swiftDataService,
            themeService: themeService,
            deepLinkService: deepLinkService
        )

        let repositories = AppRepositories(
            homeRepository: HomeRepository(remoteService: MockHomeRemoteService()),
            deepLinkHistoryRepository: DeepLinkHistoryRepository(store: deepLinkStore)
        )

        let appCore = AppCore(services: services, repositories: repositories)
        appCore.updateThemeMode(.dark)
        return appCore
    }()
}
