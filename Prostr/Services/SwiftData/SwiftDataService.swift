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
}
