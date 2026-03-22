//
//  RootView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct RootView: View {
    @State private var appCore: AppCore?

    var body: some View {
        Group {
            if let appCore {
                TabsView(appCore: appCore)
                    .environment(appCore)
                    .appTheme(appCore.appTheme)
                    .preferredColorScheme(appCore.preferredColorScheme)
                    .tint(appCore.appTheme.accentTint)
                    .onOpenURL { url in
                        appCore.handleIncomingURL(url)
                    }
            } else {
                SplashView()
            }
        }
        .task {
            guard appCore == nil else { return }

            // Swap `.mocked` for `.live(baseURL:)` once the real planner API is ready.
            let core = AppCoreFactory.make(dataMode: .mocked)
            await core.bootstrap()
            appCore = core
        }
    }
}

private struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.indigo.opacity(0.95), Color.cyan.opacity(0.55)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 18) {
                Image(systemName: "sparkles.rectangle.stack.fill")
                    .font(.system(size: 42, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)

                VStack(spacing: 8) {
                    Text("Preparing Prostr")
                        .font(.system(.title2, design: .rounded, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Loading the app core, theme, and persistence stack.")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(.white.opacity(0.88))
                        .multilineTextAlignment(.center)
                }

                ProgressView()
                    .tint(.white)
            }
            .padding(28)
            .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(.white.opacity(0.18), lineWidth: 1)
            )
            .padding(24)
        }
    }
}

#Preview {
    SplashView()
}
