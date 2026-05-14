//
//  SignUpViewModel.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class SignUpViewModel {
    private let authService: any AuthServiceProtocol
    private let passwordValidator = PasswordValidator()

    var email = ""
    var password = ""
    var isPasswordVisible = false

    private(set) var isSubmitting = false
    private(set) var hasAttemptedSubmit = false
    private(set) var serviceErrorMessage: String?

    init(authService: any AuthServiceProtocol) {
        self.authService = authService
    }

    var emailErrorMessage: String? {
        guard shouldShowEmailValidation, !AuthEmailValidator.isValid(email) else {
            return nil
        }

        return "Email is incorrect."
    }

    var shouldShowEmailValidation: Bool {
        hasAttemptedSubmit || !trimmedEmail.isEmpty
    }

    var shouldShowPasswordRequirements: Bool {
        hasAttemptedSubmit || !password.isEmpty
    }

    var unmetPasswordRequirements: [PasswordRequirement] {
        guard shouldShowPasswordRequirements else {
            return []
        }

        return passwordValidator.unmetRequirements(for: password)
    }

    func handleEmailChanged() {
        serviceErrorMessage = nil
    }

    func handlePasswordChanged() {
        serviceErrorMessage = nil
    }

    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    func submit() async -> AuthSession? {
        hasAttemptedSubmit = true

        guard emailErrorMessage == nil, unmetPasswordRequirements.isEmpty else {
            return nil
        }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let session = try await authService.signUp(
                with: EmailAuthCredentials(
                    email: email,
                    password: password
                )
            )
            serviceErrorMessage = nil
            return session
        } catch {
            serviceErrorMessage = "Unable to create your account right now."
            Log.error(error)
            return nil
        }
    }

    func authenticate(with provider: AuthProvider) async -> AuthSession? {
        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let session = try await authService.authenticate(using: provider)
            serviceErrorMessage = nil
            return session
        } catch {
            serviceErrorMessage = "Unable to continue with \(provider.rawValue.capitalized) right now."
            Log.error(error)
            return nil
        }
    }
}

private extension SignUpViewModel {
    var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
