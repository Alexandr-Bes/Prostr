//
//  SignInViewModel.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class SignInViewModel {
    private let authService: any AuthServiceProtocol

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

    var passwordErrorMessage: String? {
        guard hasAttemptedSubmit, trimmedPassword.isEmpty else {
            return nil
        }

        return "Enter your password."
    }

    var shouldShowEmailValidation: Bool {
        hasAttemptedSubmit || !trimmedEmail.isEmpty
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

        guard emailErrorMessage == nil, passwordErrorMessage == nil else {
            return nil
        }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let session = try await authService.signIn(
                with: EmailAuthCredentials(
                    email: email,
                    password: password
                )
            )
            serviceErrorMessage = nil
            return session
        } catch {
            serviceErrorMessage = "Unable to sign you in right now."
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

private extension SignInViewModel {
    var trimmedEmail: String {
        email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedPassword: String {
        password.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
