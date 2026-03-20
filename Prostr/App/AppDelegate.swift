//
//  AppDelegate.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        Log.info("Application did finish launching")
        return true
    }
}
