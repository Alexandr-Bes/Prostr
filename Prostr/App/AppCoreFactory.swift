//
//  AppCoreFactory.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
enum AppCoreFactory {
    static func make() -> AppCore {
        let localStorage = UserDefaultsStorageAdapter()
        let swiftDataService = SwiftDataService()
        let themeService = ThemeService(localStorage: localStorage)
        let deepLinkService = AppDeepLinkService()
        let deepLinkStore = SwiftDataDeepLinkHistoryStore(swiftData: swiftDataService)
        let homeRemoteService = MockHomeRemoteService()

        let services = AppServices(
            swiftDataService: swiftDataService,
            themeService: themeService,
            deepLinkService: deepLinkService
        )

        let repositories = AppRepositories(
            homeRepository: HomeRepository(remoteService: homeRemoteService),
            deepLinkHistoryRepository: DeepLinkHistoryRepository(store: deepLinkStore)
        )

        return AppCore(services: services, repositories: repositories)
    }
}
