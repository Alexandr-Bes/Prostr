//
//  NetworkClient.swift
//  Networking
//

import Foundation

public protocol NetworkClient: Sendable {
    func send<Response: Decodable>(_ endpoint: any APIEndpoint, responseType: Response.Type) async throws -> Response
}
