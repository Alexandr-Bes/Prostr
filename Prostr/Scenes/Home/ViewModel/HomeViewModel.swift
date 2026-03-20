//
//  HomeViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let homeRepository: any HomeRepositoryProtocol
    private let deepLinkHistoryRepository: any DeepLinkHistoryRepositoryProtocol

    private var hasLoaded = false

    private(set) var features: [AppFeature] = []
    private(set) var recentDeepLinks: [DeepLinkRecord] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    init(homeRepository: any HomeRepositoryProtocol,
         deepLinkHistoryRepository: any DeepLinkHistoryRepositoryProtocol) {
        self.homeRepository = homeRepository
        self.deepLinkHistoryRepository = deepLinkHistoryRepository
    }

    func loadIfNeeded() async {
        if hasLoaded {
            await refreshRecentDeepLinks()
            return
        }

        await reload()
    }

    func reload() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            features = try await homeRepository.fetchHighlights()
            recentDeepLinks = try await deepLinkHistoryRepository.fetchRecent(limit: 3)
            hasLoaded = true
        } catch {
            errorMessage = "The starter modules could not be loaded right now."
            Log.error(error)
        }
    }

    func refreshRecentDeepLinks() async {
        do {
            recentDeepLinks = try await deepLinkHistoryRepository.fetchRecent(limit: 3)
        } catch {
            Log.error(error)
        }
    }

    func feature(withID id: String) -> AppFeature? {
        features.first { $0.id == id }
    }
}
