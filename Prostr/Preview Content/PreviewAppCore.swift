//
//  PreviewAppCore.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

@MainActor
enum PreviewAppCore {
    // Screen previews should start from the same mocked dashboard state as the app shell.
    static func make(themeMode: ThemeMode = .light) -> AppCore {
        AppCoreFactory.makePreview(themeMode: themeMode)
    }
}

@MainActor
extension View {
    func previewAppCore() -> some View {
        previewAppCore(PreviewAppCore.make())
    }

    func previewAppCore(_ appCore: AppCore) -> some View {
        let previewColorScheme = appCore.preferredColorScheme ?? .light
        let theme = appCore.appTheme(for: previewColorScheme)

        return environment(appCore)
            .appTheme(theme)
            .preferredColorScheme(appCore.preferredColorScheme)
            .tint(theme.accentTint)
    }
}
