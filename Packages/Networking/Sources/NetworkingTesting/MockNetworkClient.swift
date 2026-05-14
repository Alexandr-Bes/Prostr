//
//  MockNetworkClient.swift
//  NetworkingTesting
//

import Foundation
import Networking

public struct MockNetworkClient: NetworkClient, @unchecked Sendable {
    public typealias Handler = @Sendable (any APIEndpoint) async throws -> Data

    private let handler: Handler
    private let decoder: JSONDecoder

    public init(decoder: JSONDecoder = JSONDecoder(), handler: @escaping Handler) {
        self.handler = handler
        self.decoder = decoder
    }

    public func send<Response: Decodable>(
        _ endpoint: any APIEndpoint,
        responseType: Response.Type
    ) async throws -> Response {
        let data = try await handler(endpoint)
        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            throw NetworkingError.decoding(error)
        }
    }
}

public extension MockNetworkClient {
    static func responding<Value: Encodable>(
        with value: Value,
        encoder: JSONEncoder = JSONEncoder(),
        decoder: JSONDecoder = JSONDecoder()
    ) -> MockNetworkClient {
        do {
            let data = try encoder.encode(value)
            return MockNetworkClient(decoder: decoder) { _ in data }
        } catch {
            let errorDescription = error.localizedDescription
            return MockNetworkClient(decoder: decoder) { _ in
                throw MockNetworkClientEncodingError(description: errorDescription)
            }
        }
    }

    static func respondingRaw(
        with data: Data,
        decoder: JSONDecoder = JSONDecoder()
    ) -> MockNetworkClient {
        MockNetworkClient(decoder: decoder) { _ in data }
    }

    static func failing(with error: any Error) -> MockNetworkClient {
        MockNetworkClient { _ in throw error }
    }

    static func routing(
        _ routes: [String: @Sendable (any APIEndpoint) async throws -> Data],
        fallback: Handler? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) -> MockNetworkClient {
        MockNetworkClient(decoder: decoder) { endpoint in
            if let route = routes[endpoint.path] {
                return try await route(endpoint)
            }
            if let fallback {
                return try await fallback(endpoint)
            }
            throw MockNetworkClientError.unhandledEndpoint(path: endpoint.path)
        }
    }
}

private struct MockNetworkClientEncodingError: LocalizedError, Sendable {
    let description: String

    var errorDescription: String? {
        "MockNetworkClient could not encode the provided response value: \(description)"
    }
}

public enum MockNetworkClientError: LocalizedError {
    case unhandledEndpoint(path: String)

    public var errorDescription: String? {
        switch self {
        case let .unhandledEndpoint(path):
            return "MockNetworkClient received an unhandled endpoint at path '\(path)'."
        }
    }
}
