//
//  UserDefaultsStorageAdapter.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

final class UserDefaultsStorageAdapter: LocalStorageAdapter {
    private let userDefaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(suiteName: String? = nil) {
        if let suiteName, let customDefaults = UserDefaults(suiteName: suiteName) {
            self.userDefaults = customDefaults
        } else {
            self.userDefaults = .standard
        }
    }

    func set<T: Codable>(_ value: T, for key: any KeyValueStorageKey) {
        guard let encoded = try? encoder.encode(value) else { return }
        userDefaults.set(encoded, forKey: key.rawValue)
    }

    func get<T: Codable>(for key: any KeyValueStorageKey, default defaultValue: T) -> T {
        guard let data = userDefaults.data(forKey: key.rawValue),
              let decoded = try? decoder.decode(T.self, from: data) else {
            return defaultValue
        }

        return decoded
    }
}
