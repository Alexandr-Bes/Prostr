//
//  PasswordRequirement.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

enum PasswordRequirement: String, CaseIterable, Equatable, Identifiable {
    case minimumLength
    case uppercaseLetter

    var id: String { rawValue }

    var description: String {
        switch self {
        case .minimumLength:
            return "at least 8 characters"
        case .uppercaseLetter:
            return "at least 1 uppercase letter"
        }
    }

    func isSatisfied(by password: String) -> Bool {
        switch self {
        case .minimumLength:
            return password.count >= 8
        case .uppercaseLetter:
            return password.contains(where: \.isUppercase)
        }
    }
}
