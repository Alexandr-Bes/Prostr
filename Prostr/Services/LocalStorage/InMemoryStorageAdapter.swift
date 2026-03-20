//
//  InMemoryStorageAdapter.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

final class InMemoryStorageAdapter: LocalStorageAdapter {
    private var storage: [String: Data] = [:]
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func set<T: Codable>(_ value: T, for key: any KeyValueStorageKey) {
        guard let encoded = try? encoder.encode(value) else { return }
        storage[key.rawValue] = encoded
    }

    func get<T: Codable>(for key: any KeyValueStorageKey, default defaultValue: T) -> T {
        guard let data = storage[key.rawValue],
              let decoded = try? decoder.decode(T.self, from: data) else {
            return defaultValue
        }

        return decoded
    }
}
