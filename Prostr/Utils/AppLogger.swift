//
//  AppLogger.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import OSLog

enum Log {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "com.testSwiftUI.Prostr",
        category: "Prostr"
    )

    static func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    static func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }

    static func error(_ error: Error) {
        logger.error("\(String(describing: error), privacy: .public)")
    }
}
