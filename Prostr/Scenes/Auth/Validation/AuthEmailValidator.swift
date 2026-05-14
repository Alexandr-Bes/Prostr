//
//  AuthEmailValidator.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

struct AuthEmailValidator {
    static func isValid(_ email: String) -> Bool {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, trimmedEmail.count <= 254 else {
            return false
        }

        let pattern = #"^[A-Z0-9._%+\-]+@[A-Z0-9.\-]+\.[A-Z]{2,}$"#

        return trimmedEmail.range(
            of: pattern,
            options: [.regularExpression, .caseInsensitive]
        ) != nil
    }
}
