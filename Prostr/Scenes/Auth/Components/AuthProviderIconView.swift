//
//  AuthProviderIconView.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthProviderIconView: View {
    let provider: AuthProvider

    var body: some View {
        switch provider {
        case .emailPassword:
            Image(systemName: "envelope")
                .font(.headline)
        case .google:
            Text("G")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            Color(hex: "4285F4"),
                            Color(hex: "34A853"),
                            Color(hex: "FBBC05"),
                            Color(hex: "EA4335")
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        case .facebook:
            ZStack {
                Circle()
                    .fill(Color(hex: "1877F2"))

                Text("f")
                    .font(.system(size: 18, weight: .black, design: .rounded))
                    .foregroundStyle(.white)
                    .offset(y: 1)
            }
            .frame(width: 24, height: 24)
        case .apple:
            Image(systemName: "apple.logo")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(.primary)
        }
    }
}
