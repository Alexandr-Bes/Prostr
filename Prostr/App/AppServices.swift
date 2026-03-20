//
//  AppServices.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

struct AppServices {
    let swiftDataService: any SwiftDataServiceProtocol
    let themeService: any ThemeServiceProtocol
    let deepLinkService: any DeepLinkServiceProtocol
}
