//
//  LocalStorageAdapter.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation

@MainActor
protocol LocalStorageAdapter {
    func set<T: Codable>(_ value: T, for key: any KeyValueStorageKey)
    func get<T: Codable>(for key: any KeyValueStorageKey, default defaultValue: T) -> T
}
