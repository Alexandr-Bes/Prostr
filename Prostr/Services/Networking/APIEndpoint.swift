//
//  APIEndpoint.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

protocol APIEndpoint {
    nonisolated var path: String { get }
    nonisolated var method: HTTPMethod { get }
    nonisolated var headers: [String: String] { get }
    nonisolated var queryItems: [URLQueryItem] { get }
    nonisolated var body: Data? { get }
}

extension APIEndpoint {
    nonisolated var headers: [String: String] { [:] }
    nonisolated var queryItems: [URLQueryItem] { [] }
    nonisolated var body: Data? { nil }
}
