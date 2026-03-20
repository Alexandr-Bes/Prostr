//
//  SettingsViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class SettingsViewModel {
    private let deepLinkHistoryRepository: any DeepLinkHistoryRepositoryProtocol
    private let onThemeModeChange: (ThemeMode) -> Void

    private(set) var recentDeepLinks: [DeepLinkRecord] = []
    var selectedThemeMode: ThemeMode

    let previewRoutes: [DeepLinkRoute] = [
        .tab(.home),
        .feature(id: "routing"),
        .tab(.settings)
    ]

    init(initialThemeMode: ThemeMode,
         deepLinkHistoryRepository: any DeepLinkHistoryRepositoryProtocol,
         onThemeModeChange: @escaping (ThemeMode) -> Void) {
        self.selectedThemeMode = initialThemeMode
        self.deepLinkHistoryRepository = deepLinkHistoryRepository
        self.onThemeModeChange = onThemeModeChange
    }

    func updateThemeMode(_ mode: ThemeMode) {
        selectedThemeMode = mode
        onThemeModeChange(mode)
    }

    func refreshHistory() async {
        do {
            recentDeepLinks = try await deepLinkHistoryRepository.fetchRecent(limit: 8)
        } catch {
            Log.error(error)
        }
    }
}
