//
//  DeepLinkHistoryRepository.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
protocol DeepLinkHistoryRepositoryProtocol {
    func record(_ route: DeepLinkRoute) async throws
    func fetchRecent(limit: Int) async throws -> [DeepLinkRecord]
}

@MainActor
final class DeepLinkHistoryRepository: DeepLinkHistoryRepositoryProtocol {
    private let store: any DeepLinkHistoryStoreProtocol

    init(store: any DeepLinkHistoryStoreProtocol) {
        self.store = store
    }

    func record(_ route: DeepLinkRoute) async throws {
        try await store.record(routeValue: route.storageValue, openedAt: .now)
    }

    func fetchRecent(limit: Int) async throws -> [DeepLinkRecord] {
        let entities = try await store.fetchRecent(limit: limit)

        return entities.compactMap { entity in
            guard let route = DeepLinkRoute(storageValue: entity.routeValue) else {
                return nil
            }

            return DeepLinkRecord(id: entity.id, route: route, openedAt: entity.openedAt)
        }
    }
}
