//
//  SwiftDataPlannerContentCardStore.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import Foundation
import SwiftData

@MainActor
protocol PlannerContentCardStoreProtocol {
    func fetchPosts() async throws -> [PlannerContentCard]
    func fetchPost(id: String) async throws -> PlannerContentCard?
    func createPost(_ card: PlannerContentCard) async throws
    func updatePost(_ card: PlannerContentCard) async throws
    func deletePost(id: String) async throws
}

@MainActor
final class SwiftDataPlannerContentCardStore: PlannerContentCardStoreProtocol {
    private let swiftData: any SwiftDataServiceProtocol

    init(swiftData: any SwiftDataServiceProtocol) {
        self.swiftData = swiftData
    }

    func fetchPosts() async throws -> [PlannerContentCard] {
        let descriptor = FetchDescriptor<SwiftDataPlannerContentCardRecord>(
            sortBy: [SortDescriptor(\.updatedAt, order: .reverse)]
        )

        return try swiftData.fetch(descriptor).compactMap { $0.toPlannerContentCard() }
    }

    func fetchPost(id: String) async throws -> PlannerContentCard? {
        try fetchRecord(for: id)?.toPlannerContentCard()
    }

    func createPost(_ card: PlannerContentCard) async throws {
        guard try fetchRecord(for: card.id) == nil else {
            try await updatePost(card)
            return
        }

        swiftData.insert(makeRecord(from: card))
        try swiftData.save()
    }

    func updatePost(_ card: PlannerContentCard) async throws {
        guard let existingRecord = try fetchRecord(for: card.id) else {
            try await createPost(card)
            return
        }

        update(existingRecord, with: card)
        try swiftData.save()
    }

    func deletePost(id: String) async throws {
        guard let existingRecord = try fetchRecord(for: id) else {
            return
        }

        swiftData.delete(existingRecord)
        try swiftData.save()
    }
}

private extension SwiftDataPlannerContentCardStore {
    func fetchRecord(for id: String) throws -> SwiftDataPlannerContentCardRecord? {
        var descriptor = FetchDescriptor<SwiftDataPlannerContentCardRecord>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        return try swiftData.fetch(descriptor).first
    }

    func makeRecord(from card: PlannerContentCard) -> SwiftDataPlannerContentCardRecord {
        SwiftDataPlannerContentCardRecord(
            id: card.id,
            title: card.title,
            subtitle: card.subtitle,
            bodyText: card.bodyText,
            stateValue: card.state.rawValue,
            platformValue: card.platform.rawValue,
            postTypeValue: card.postType.rawValue,
            createdAt: card.createdAt,
            postDate: card.postDate,
            imageAssetName: card.imageAssetName,
            imageData: card.imageData,
            tag: card.tag,
            detailTagsValue: encode(card.detailTags),
            hashtagsValue: encode(card.hashtags)
        )
    }

    func update(_ record: SwiftDataPlannerContentCardRecord, with card: PlannerContentCard) {
        record.title = card.title
        record.subtitle = card.subtitle
        record.bodyText = card.bodyText
        record.stateValue = card.state.rawValue
        record.platformValue = card.platform.rawValue
        record.postTypeValue = card.postType.rawValue
        record.createdAt = card.createdAt
        record.postDate = card.postDate
        record.imageAssetName = card.imageAssetName
        record.imageData = card.imageData
        record.tag = card.tag
        record.detailTagsValue = encode(card.detailTags)
        record.hashtagsValue = encode(card.hashtags)
        record.updatedAt = .now
    }

    func encode(_ values: [String]) -> String {
        guard let data = try? JSONEncoder().encode(values),
              let string = String(data: data, encoding: .utf8) else {
            return "[]"
        }

        return string
    }
}

private extension SwiftDataPlannerContentCardRecord {
    func toPlannerContentCard() -> PlannerContentCard? {
        guard let state = PlannerCardState(rawValue: stateValue),
              let platform = PlannerPlatform(rawValue: platformValue),
              let postType = PlannerPostType(rawValue: postTypeValue) else {
            return nil
        }

        return PlannerContentCard(
            id: id,
            title: title,
            subtitle: subtitle,
            bodyText: bodyText,
            state: state,
            platform: platform,
            postType: postType,
            createdAt: createdAt,
            postDate: postDate,
            imageAssetName: imageAssetName,
            imageData: imageData,
            tag: tag,
            detailTags: decode(detailTagsValue),
            hashtags: decode(hashtagsValue)
        )
    }

    func decode(_ value: String) -> [String] {
        guard let data = value.data(using: .utf8),
              let decoded = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }

        return decoded
    }
}
