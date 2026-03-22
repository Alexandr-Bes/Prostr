//
//  DeepLinkService.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
protocol DeepLinkServiceProtocol {
    func parse(url: URL) -> DeepLinkRoute?
    func makeURL(for route: DeepLinkRoute) -> URL?
}

struct AppDeepLinkService: DeepLinkServiceProtocol {
    let scheme: String

    init(scheme: String = "prostr") {
        self.scheme = scheme
    }

    func parse(url: URL) -> DeepLinkRoute? {
        guard url.scheme?.lowercased() == scheme else {
            return nil
        }

        let host = (url.host ?? "").lowercased()
        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []

        func value(_ name: String) -> String? {
            queryItems.first(where: { $0.name == name })?.value
        }

        switch host {
        case "home":
            return .tab(.calendar)
        case "calendar":
            return .tab(.calendar)
        case "todo":
            return .tab(.todo)
        case "ideas":
            return .tab(.ideas)

        case "feature":
            guard let id = value("id"), !id.isEmpty else {
                return nil
            }

            return .feature(id: id)

        default:
            return nil
        }
    }

    func makeURL(for route: DeepLinkRoute) -> URL? {
        var components = URLComponents()
        components.scheme = scheme

        switch route {
        case let .tab(tab):
            components.host = tab.rawValue

        case let .feature(id):
            components.host = "feature"
            components.queryItems = [URLQueryItem(name: "id", value: id)]
        }

        return components.url
    }
}
