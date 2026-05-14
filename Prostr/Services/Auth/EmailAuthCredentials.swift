//
//  EmailAuthCredentials.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

struct EmailAuthCredentials: Equatable, Sendable {
    let email: String
    let password: String

    var normalizedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
}
