//
//  AuthProvider.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

enum AuthProvider: String, Codable, CaseIterable, Equatable, Identifiable {
    case emailPassword
    case google
    case facebook
    case apple

    var id: String { rawValue }

    var socialButtonTitle: String {
        switch self {
        case .emailPassword:
            return ""
        case .google:
            return "Continue with Google"
        case .facebook:
            return "Continue with Facebook"
        case .apple:
            return "Continue with Apple"
        }
    }
}
