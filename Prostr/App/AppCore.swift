//
//  AppCore.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Observation
import SwiftUI

@Observable
@MainActor
final class AppCore {
    let services: AppServices
    let repositories: AppRepositories

    private(set) var isBootstrapped = false
    private(set) var selectedThemeMode: ThemeMode = .system
    private(set) var lastHandledRoute: DeepLinkRoute?

    var selectedTab: AppTab = .home
    var homePath: [String] = []

    init(services: AppServices, repositories: AppRepositories) {
        self.services = services
        self.repositories = repositories
    }

    var appTheme: AppTheme {
        services.themeService.theme
    }

    var preferredColorScheme: ColorScheme? {
        selectedThemeMode.colorScheme
    }

    func bootstrap() async {
        guard !isBootstrapped else { return }

        selectedThemeMode = services.themeService.loadThemeMode()
        isBootstrapped = true
    }

    func updateThemeMode(_ mode: ThemeMode) {
        selectedThemeMode = mode
        services.themeService.saveThemeMode(mode)
    }

    func handleIncomingURL(_ url: URL) {
        guard let route = services.deepLinkService.parse(url: url) else {
            Log.info("Ignored URL: \(url.absoluteString)")
            return
        }

        open(route: route)
    }

    func open(route: DeepLinkRoute) {
        apply(route: route)

        Task {
            do {
                try await repositories.deepLinkHistoryRepository.record(route)
            } catch {
                Log.error(error)
            }
        }
    }

    func makeURL(for route: DeepLinkRoute) -> URL? {
        services.deepLinkService.makeURL(for: route)
    }
}

private extension AppCore {
    func apply(route: DeepLinkRoute) {
        lastHandledRoute = route

        switch route {
        case let .tab(tab):
            selectedTab = tab
            if tab == .home {
                homePath.removeAll()
            }

        case let .feature(id):
            selectedTab = .home
            homePath = [id]
        }
    }
}
