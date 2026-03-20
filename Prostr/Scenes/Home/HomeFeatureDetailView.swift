//
//  HomeFeatureDetailView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct HomeFeatureDetailView: View {
    @Environment(AppCore.self) private var appCore
    @Environment(\.appTheme) private var theme

    let featureID: String
    let viewModel: HomeViewModel

    private var feature: AppFeature? {
        viewModel.feature(withID: featureID)
    }

    var body: some View {
        ScrollView {
            if let feature {
                VStack(alignment: .leading, spacing: 24) {
                    FeatureCard(feature: feature)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Why This Exists")
                            .font(.system(.title3, design: .rounded, weight: .bold))
                            .foregroundStyle(theme.primaryText)

                        Text(feature.detail)
                            .font(.system(.body, design: .rounded))
                            .foregroundStyle(theme.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Sample Deep Link")
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(theme.primaryText)

                        Text(appCore.makeURL(for: feature.suggestedRoute)?.absoluteString ?? "prostr://home")
                            .font(.system(.body, design: .monospaced))
                            .foregroundStyle(theme.primaryText)
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(theme.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .stroke(theme.cardBorder, lineWidth: 1)
                            )
                    }

                    Button {
                        appCore.open(route: .tab(.settings))
                    } label: {
                        Label("Inspect Theme & Routing Setup", systemImage: "arrow.triangle.branch")
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(theme.accentTint)
                }
                .padding(20)
            } else {
                ContentUnavailableView(
                    "Feature Unavailable",
                    systemImage: "questionmark.square.dashed",
                    description: Text("The selected feature is not available in the current repository payload.")
                )
                .padding(.top, 80)
            }
        }
        .background(background.ignoresSafeArea())
        .navigationTitle(feature?.title ?? "Feature")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension HomeFeatureDetailView {
    var background: LinearGradient {
        LinearGradient(
            colors: [theme.canvasTop, theme.canvasBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
