//
//  AuthServiceTests.swift
//  ProstrTests
//
//  Created by Alex on 31.03.2026.
//

import Testing
@testable import Prostr

struct AuthServiceTests {
    @Test
    @MainActor
    func authServicePersistsAndClearsSession() async throws {
        let storage = InMemoryStorageAdapter()
        let service = AuthService(localStorage: storage)

        #expect(service.loadSession() == nil)

        let session = try await service.signUp(
            with: EmailAuthCredentials(
                email: "User@Example.com ",
                password: "Password1"
            )
        )

        #expect(session.email == "user@example.com")
        #expect(service.loadSession() == session)

        service.signOut()

        #expect(service.loadSession() == nil)
    }

    @Test
    @MainActor
    func socialAuthenticationCreatesProviderSession() async throws {
        let service = AuthService(localStorage: InMemoryStorageAdapter())

        let session = try await service.authenticate(using: .google)

        #expect(session.provider == .google)
        #expect(session.email == "google.user@prostr.app")
    }
}
