//
//  HomeRemoteService.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

protocol HomeRemoteServiceProtocol {
    nonisolated func fetchStarterHighlights() async throws -> [AppFeature]
}

nonisolated struct RemoteHomeHighlightsEndpoint: APIEndpoint {
    let path = "/starter-highlights"
    let method: HTTPMethod = .get
}

nonisolated struct RemoteHomeFeatureResponse: Decodable {
    let id: String
    let title: String
    let subtitle: String
    let detail: String
    let symbolName: String
    let accentStyle: String
}

nonisolated struct RemoteHomeRemoteService: HomeRemoteServiceProtocol {
    private let networkClient: any NetworkClient

    init(networkClient: any NetworkClient) {
        self.networkClient = networkClient
    }

    nonisolated func fetchStarterHighlights() async throws -> [AppFeature] {
        let response = try await networkClient.send(
            RemoteHomeHighlightsEndpoint(),
            responseType: [RemoteHomeFeatureResponse].self
        )

        return response.map { item in
            AppFeature(
                id: item.id,
                title: item.title,
                subtitle: item.subtitle,
                detail: item.detail,
                symbolName: item.symbolName,
                accentStyle: FeatureAccentStyle(rawValue: item.accentStyle) ?? .ocean,
                suggestedRoute: .feature(id: item.id)
            )
        }
    }
}

nonisolated struct MockHomeRemoteService: HomeRemoteServiceProtocol {
    nonisolated func fetchStarterHighlights() async throws -> [AppFeature] {
        try await Task.sleep(for: .milliseconds(200))
        return AppFeature.starterHighlights
    }
}
