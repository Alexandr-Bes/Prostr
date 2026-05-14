//
//  URLSessionNetworkClient.swift
//  Networking
//

import Foundation

public struct URLSessionNetworkClient: NetworkClient, @unchecked Sendable {
    public let baseURL: URL
    public var session: URLSession
    public var decoder: JSONDecoder

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    public func send<Response: Decodable>(
        _ endpoint: any APIEndpoint,
        responseType: Response.Type
    ) async throws -> Response {
        let request = try makeRequest(for: endpoint)

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.invalidResponse
            }

            guard (200 ... 299).contains(httpResponse.statusCode) else {
                throw NetworkingError.invalidStatusCode(httpResponse.statusCode)
            }

            do {
                return try decoder.decode(Response.self, from: data)
            } catch {
                throw NetworkingError.decoding(error)
            }
        } catch let networkingError as NetworkingError {
            throw networkingError
        } catch {
            throw NetworkingError.transport(error)
        }
    }
}

private extension URLSessionNetworkClient {
    func makeRequest(for endpoint: any APIEndpoint) throws -> URLRequest {
        let trimmedPath = endpoint.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        let endpointURL = trimmedPath.isEmpty ? baseURL : baseURL.appendingPathComponent(trimmedPath)

        guard var components = URLComponents(url: endpointURL, resolvingAgainstBaseURL: false) else {
            throw NetworkingError.invalidURL
        }

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }

        guard let url = components.url else {
            throw NetworkingError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body

        for (key, value) in endpoint.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
