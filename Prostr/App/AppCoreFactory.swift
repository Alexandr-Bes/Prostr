//
//  AppCoreFactory.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
enum AppCoreFactory {
    // Use `.mocked` while the planner backend is not wired yet.
    static func make(dataMode: AppDataMode = .mocked) -> AppCore {
        make(
            dataMode: dataMode,
            isStoredInMemoryOnly: false,
            preferredThemeMode: nil
        )
    }

    // Previews reuse the same mocked planner data, but keep persistence in memory.
    static func makePreview(themeMode: ThemeMode = .light) -> AppCore {
        make(
            dataMode: .mocked,
            isStoredInMemoryOnly: true,
            preferredThemeMode: themeMode
        )
    }

    private static func make(
        dataMode: AppDataMode,
        isStoredInMemoryOnly: Bool,
        preferredThemeMode: ThemeMode?
    ) -> AppCore {
        let localStorage: any LocalStorageAdapter = isStoredInMemoryOnly ? InMemoryStorageAdapter() : UserDefaultsStorageAdapter()
        let swiftDataService = SwiftDataService(
            containerProvider: ModelContainerProvider(isStoredInMemoryOnly: isStoredInMemoryOnly)
        )
        let themeService = ThemeService(localStorage: localStorage)
        let deepLinkService = AppDeepLinkService()
        let deepLinkStore = SwiftDataDeepLinkHistoryStore(swiftData: swiftDataService)
        let plannerContentCardStore = SwiftDataPlannerContentCardStore(swiftData: swiftDataService)
        let plannerDashboardService = makePlannerDashboardService(for: dataMode)

        let services = AppServices(
            swiftDataService: swiftDataService,
            themeService: themeService,
            deepLinkService: deepLinkService
        )

        let repositories = AppRepositories(
            plannerDashboardRepository: PlannerDashboardRepository(
                service: plannerDashboardService,
                contentCardStore: plannerContentCardStore
            ),
            deepLinkHistoryRepository: DeepLinkHistoryRepository(store: deepLinkStore)
        )

        let appCore = AppCore(services: services, repositories: repositories)

        if let preferredThemeMode {
            appCore.updateThemeMode(preferredThemeMode)
        }

        return appCore
    }

    private static func makePlannerDashboardService(for dataMode: AppDataMode) -> any PlannerDashboardServiceProtocol {
        switch dataMode {
        case .mocked:
            return MockPlannerDashboardService()
        case let .live(baseURL):
            return LivePlannerDashboardService(
                networkClient: URLSessionNetworkClient(baseURL: baseURL)
            )
        }
    }
}
