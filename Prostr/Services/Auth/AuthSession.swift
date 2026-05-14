//
//  AuthSession.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

struct AuthSession: Codable, Equatable {
    let email: String
    let provider: AuthProvider
    let startedAt: Date
}
