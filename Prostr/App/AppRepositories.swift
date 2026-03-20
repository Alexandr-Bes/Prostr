//
//  AppRepositories.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

struct AppRepositories {
    let homeRepository: any HomeRepositoryProtocol
    let deepLinkHistoryRepository: any DeepLinkHistoryRepositoryProtocol
}
