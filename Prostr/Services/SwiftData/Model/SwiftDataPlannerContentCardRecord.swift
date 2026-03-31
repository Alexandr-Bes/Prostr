//
//  SwiftDataPlannerContentCardRecord.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import Foundation
import SwiftData

@Model
final class SwiftDataPlannerContentCardRecord {
    @Attribute(.unique) var id: String
    var title: String
    var subtitle: String
    var bodyText: String
    var stateValue: String
    var platformValue: String
    var postTypeValue: String
    var createdAt: Date
    var postDate: Date?
    var imageAssetName: String?
    @Attribute(.externalStorage) var imageData: Data?
    var tag: String?
    var detailTagsValue: String
    var hashtagsValue: String
    var updatedAt: Date

    init(
        id: String,
        title: String,
        subtitle: String,
        bodyText: String,
        stateValue: String,
        platformValue: String,
        postTypeValue: String,
        createdAt: Date,
        postDate: Date?,
        imageAssetName: String?,
        imageData: Data?,
        tag: String?,
        detailTagsValue: String,
        hashtagsValue: String,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.bodyText = bodyText
        self.stateValue = stateValue
        self.platformValue = platformValue
        self.postTypeValue = postTypeValue
        self.createdAt = createdAt
        self.postDate = postDate
        self.imageAssetName = imageAssetName
        self.imageData = imageData
        self.tag = tag
        self.detailTagsValue = detailTagsValue
        self.hashtagsValue = hashtagsValue
        self.updatedAt = updatedAt
    }
}
