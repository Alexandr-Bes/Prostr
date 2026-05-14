//
//  AuthValidationTests.swift
//  ProstrTests
//
//  Created by Alex on 31.03.2026.
//

import Testing
@testable import Prostr

struct AuthValidationTests {
    @Test
    func emailValidatorRejectsMalformedInput() {
        #expect(AuthEmailValidator.isValid("wrong-email") == false)
        #expect(AuthEmailValidator.isValid("name@example.com"))
    }

    @Test
    func passwordValidatorTracksMissingRequirements() {
        let validator = PasswordValidator()

        #expect(validator.unmetRequirements(for: "123_test") == [.uppercaseLetter])
        #expect(validator.isValid("Password1"))
    }
}
