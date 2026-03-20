//
//  DeepLinkRecord.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

struct DeepLinkRecord: Identifiable, Hashable {
    let id: UUID
    let route: DeepLinkRoute
    let openedAt: Date
}
