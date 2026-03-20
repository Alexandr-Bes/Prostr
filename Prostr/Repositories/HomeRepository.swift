//
//  HomeRepository.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
protocol HomeRepositoryProtocol {
    func fetchHighlights() async throws -> [AppFeature]
}

final class HomeRepository: HomeRepositoryProtocol {
    private let remoteService: any HomeRemoteServiceProtocol

    init(remoteService: any HomeRemoteServiceProtocol) {
        self.remoteService = remoteService
    }

    func fetchHighlights() async throws -> [AppFeature] {
        try await remoteService.fetchStarterHighlights()
    }
}
