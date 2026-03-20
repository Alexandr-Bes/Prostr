//
//  NetworkClient.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

protocol NetworkClient {
    nonisolated func send<Response: Decodable>(_ endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response
}

nonisolated struct URLSessionNetworkClient: NetworkClient {
    let baseURL: URL
    var session: URLSession = .shared
    var decoder: JSONDecoder = .init()

    nonisolated func send<Response: Decodable>(_ endpoint: APIEndpoint, responseType: Response.Type) async throws -> Response {
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
    nonisolated func makeRequest(for endpoint: APIEndpoint) throws -> URLRequest {
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

        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }

        return request
    }
}
