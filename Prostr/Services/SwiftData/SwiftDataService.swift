//
//  SwiftDataService.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import SwiftData

@MainActor
protocol SwiftDataServiceProtocol {
    var container: ModelContainer { get }
    var context: ModelContext { get }
    func save() throws
    func insert<Model: PersistentModel>(_ model: Model)
    func delete<Model: PersistentModel>(_ model: Model)
    func fetch<Model: PersistentModel>(_ descriptor: FetchDescriptor<Model>) throws -> [Model]
}

@MainActor
final class SwiftDataService: SwiftDataServiceProtocol {
    let container: ModelContainer

    var context: ModelContext {
        container.mainContext
    }

    init(containerProvider: ModelContainerProvider) {
        self.container = containerProvider.container
    }

    convenience init() {
        self.init(containerProvider: .shared)
    }

    func save() throws {
        guard context.hasChanges else { return }
        try context.save()
    }

    func insert<Model: PersistentModel>(_ model: Model) {
        context.insert(model)
    }

    func delete<Model: PersistentModel>(_ model: Model) {
        context.delete(model)
    }

    func fetch<Model: PersistentModel>(_ descriptor: FetchDescriptor<Model>) throws -> [Model] {
        try context.fetch(descriptor)
    }
}
