//
//  NetworkingError.swift
//  Networking
//

import Foundation

public enum NetworkingError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidStatusCode(Int)
    case decoding(Error)
    case transport(Error)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The request URL could not be constructed."
        case .invalidResponse:
            return "The server response was invalid."
        case let .invalidStatusCode(code):
            return "The request failed with status code \(code)."
        case let .decoding(error):
            return "The response could not be decoded: \(error.localizedDescription)"
        case let .transport(error):
            return "The network request failed: \(error.localizedDescription)"
        }
    }
}
