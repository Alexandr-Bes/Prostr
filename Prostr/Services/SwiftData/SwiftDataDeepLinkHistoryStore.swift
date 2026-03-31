//
//  SwiftDataDeepLinkHistoryStore.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import SwiftData

@MainActor
protocol DeepLinkHistoryStoreProtocol {
    func record(routeValue: String, openedAt: Date) async throws
    func fetchRecent(limit: Int) async throws -> [SwiftDataDeepLinkRecord]
}

@MainActor
final class SwiftDataDeepLinkHistoryStore: DeepLinkHistoryStoreProtocol {
    private let swiftData: any SwiftDataServiceProtocol

    init(swiftData: any SwiftDataServiceProtocol) {
        self.swiftData = swiftData
    }

    func record(routeValue: String, openedAt: Date) async throws {
        let record = SwiftDataDeepLinkRecord(routeValue: routeValue, openedAt: openedAt)
        swiftData.insert(record)
        try swiftData.save()
    }

    func fetchRecent(limit: Int) async throws -> [SwiftDataDeepLinkRecord] {
        var descriptor = FetchDescriptor<SwiftDataDeepLinkRecord>(
            sortBy: [SortDescriptor(\.openedAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try swiftData.fetch(descriptor)
    }
}
