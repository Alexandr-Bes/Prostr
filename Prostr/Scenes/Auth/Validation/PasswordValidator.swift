//
//  PasswordValidator.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

struct PasswordValidator {
    func unmetRequirements(for password: String) -> [PasswordRequirement] {
        PasswordRequirement.allCases.filter { !$0.isSatisfied(by: password) }
    }

    func isValid(_ password: String) -> Bool {
        unmetRequirements(for: password).isEmpty
    }
}
