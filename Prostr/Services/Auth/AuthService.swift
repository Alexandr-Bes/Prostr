//
//  AuthService.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import Foundation

enum AuthServiceError: LocalizedError {
    case unsupportedProvider

    var errorDescription: String? {
        switch self {
        case .unsupportedProvider:
            return "This provider is not supported by the social auth entry point."
        }
    }
}

@MainActor
protocol AuthServiceProtocol {
    func loadSession() -> AuthSession?
    func signUp(with credentials: EmailAuthCredentials) async throws -> AuthSession
    func signIn(with credentials: EmailAuthCredentials) async throws -> AuthSession
    func authenticate(using provider: AuthProvider) async throws -> AuthSession
    func signOut()
}

@MainActor
final class AuthService: AuthServiceProtocol {
    private let localStorage: any LocalStorageAdapter

    private enum AuthStorageKey: String, KeyValueStorageKey {
        case session = "auth.session"
    }

    init(localStorage: any LocalStorageAdapter) {
        self.localStorage = localStorage
    }

    func loadSession() -> AuthSession? {
        localStorage.get(
            for: AuthStorageKey.session,
            default: Optional<AuthSession>.none
        )
    }

    func signUp(with credentials: EmailAuthCredentials) async throws -> AuthSession {
        persistSession(
            email: credentials.normalizedEmail,
            provider: .emailPassword
        )
    }

    func signIn(with credentials: EmailAuthCredentials) async throws -> AuthSession {
        persistSession(
            email: credentials.normalizedEmail,
            provider: .emailPassword
        )
    }

    func authenticate(using provider: AuthProvider) async throws -> AuthSession {
        guard provider != .emailPassword else {
            throw AuthServiceError.unsupportedProvider
        }

        return persistSession(
            email: mockEmailAddress(for: provider),
            provider: provider
        )
    }

    func signOut() {
        localStorage.set(
            Optional<AuthSession>.none,
            for: AuthStorageKey.session
        )
    }
}

private extension AuthService {
    func persistSession(email: String, provider: AuthProvider) -> AuthSession {
        let session = AuthSession(
            email: email,
            provider: provider,
            startedAt: .now
        )

        localStorage.set(session, for: AuthStorageKey.session)
        return session
    }

    func mockEmailAddress(for provider: AuthProvider) -> String {
        switch provider {
        case .emailPassword:
            return "user@prostr.app"
        case .google:
            return "google.user@prostr.app"
        case .facebook:
            return "facebook.user@prostr.app"
        case .apple:
            return "apple.user@prostr.app"
        }
    }
}
