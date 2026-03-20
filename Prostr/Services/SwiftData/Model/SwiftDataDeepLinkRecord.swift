//
//  SwiftDataDeepLinkRecord.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import SwiftData

@Model
final class SwiftDataDeepLinkRecord {
    @Attribute(.unique) var id: UUID
    var routeValue: String
    var openedAt: Date

    init(id: UUID = UUID(), routeValue: String, openedAt: Date) {
        self.id = id
        self.routeValue = routeValue
        self.openedAt = openedAt
    }
}
