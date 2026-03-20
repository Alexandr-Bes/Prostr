//
//  ModelContainerProvider.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import SwiftData

@MainActor
final class ModelContainerProvider {
    static let shared = ModelContainerProvider()

    let container: ModelContainer

    init(isStoredInMemoryOnly: Bool = false) {
        let schema = Schema([SwiftDataDeepLinkRecord.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: isStoredInMemoryOnly)

        do {
            container = try ModelContainer(for: SwiftDataDeepLinkRecord.self, configurations: configuration)
        } catch {
            Log.error(error)
            fatalError("Unable to initialize SwiftData container")
        }
    }
}
