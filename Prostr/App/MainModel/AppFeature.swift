//
//  AppFeature.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

struct AppFeature: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let detail: String
    let symbolName: String
    let accentStyle: FeatureAccentStyle
    let suggestedRoute: DeepLinkRoute

    nonisolated static let starterHighlights: [AppFeature] = [
        AppFeature(
            id: "architecture",
            title: "Modular MVVM",
            subtitle: "Scenes stay thin while repositories and services handle the heavy lifting.",
            detail: "Prostr now starts from AppCore and fans dependencies out through dedicated repositories and services. Views own presentation only, and each feature can scale without growing a monolithic starter file.",
            symbolName: "square.stack.3d.up.fill",
            accentStyle: .ocean,
            suggestedRoute: .feature(id: "architecture")
        ),
        AppFeature(
            id: "persistence",
            title: "SwiftData Ready",
            subtitle: "Persistence lives behind its own service and typed history store.",
            detail: "SwiftData support is isolated in a dedicated stack: a model container provider, a persistence service, and a deep-link history store. That keeps storage decisions out of scenes and repositories.",
            symbolName: "externaldrive.fill.badge.checkmark",
            accentStyle: .forest,
            suggestedRoute: .feature(id: "persistence")
        ),
        AppFeature(
            id: "routing",
            title: "Deep Link Routing",
            subtitle: "Custom scheme handling drives tabs and navigation paths from one place.",
            detail: "Incoming URLs are parsed through a deep-link service, passed into AppCore, and then translated into tab selection and navigation paths. The same routing path is reusable for previews, internal actions, and external entry points.",
            symbolName: "link.circle.fill",
            accentStyle: .sunset,
            suggestedRoute: .feature(id: "routing")
        )
    ]
}

enum FeatureAccentStyle: String, Hashable, Codable {
    case ocean
    case forest
    case sunset
}
