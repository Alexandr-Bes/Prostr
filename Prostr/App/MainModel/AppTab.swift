//
//  AppTab.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

enum AppTab: String, CaseIterable, Hashable, Identifiable {
    case home
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .settings:
            return "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            return "square.grid.2x2.fill"
        case .settings:
            return "slider.horizontal.3"
        }
    }
}
