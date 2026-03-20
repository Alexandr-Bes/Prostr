//
//  HomeView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppCore.self) private var appCore
    @Environment(\.appTheme) private var theme

    let viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                heroSection
                contentSection
                recentRoutesSection
            }
            .padding(20)
        }
        .background(background.ignoresSafeArea())
        .navigationTitle("Prostr")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await viewModel.loadIfNeeded()
        }
        .onAppear {
            Task {
                await viewModel.refreshRecentDeepLinks()
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appCore.selectedTab = .settings
                } label: {
                    Image(systemName: "paintpalette.fill")
                }
            }
        }
    }
}

private extension HomeView {
    var background: LinearGradient {
        LinearGradient(
            colors: [theme.canvasTop, theme.canvasBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var heroSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Project starter with room to grow.")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(.white)

            Text("MVVM, repositories, networking, SwiftData, deep links, and theme handling all start from the same composition root.")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(.white.opacity(0.92))

            HStack(spacing: 12) {
                Label("AppCore", systemImage: "app.connected.to.app.below.fill")
                Label("SwiftData", systemImage: "cylinder.split.1x2.fill")
                Label("Routing", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
            }
            .font(.system(.caption, design: .rounded, weight: .bold))
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [theme.heroStart, theme.heroEnd], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .shadow(color: theme.cardShadow, radius: 18, y: 10)
    }

    @ViewBuilder
    var contentSection: some View {
        if viewModel.isLoading && viewModel.features.isEmpty {
            VStack(spacing: 18) {
                ProgressView()
                Text("Loading starter modules...")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
            }
            .frame(maxWidth: .infinity)
            .padding(32)
        } else if let errorMessage = viewModel.errorMessage, viewModel.features.isEmpty {
            ContentUnavailableView(
                "Unable to Load Content",
                systemImage: "wifi.exclamationmark",
                description: Text(errorMessage)
            )
        } else {
            VStack(alignment: .leading, spacing: 16) {
                Text("Architecture Highlights")
                    .font(.system(.title3, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)

                ForEach(viewModel.features) { feature in
                    NavigationLink(value: feature.id) {
                        FeatureCard(feature: feature)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    @ViewBuilder
    var recentRoutesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Deep Links")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(theme.primaryText)

            if viewModel.recentDeepLinks.isEmpty {
                Text("Open a `prostr://...` link and it will show up here through the SwiftData-backed history repository.")
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.secondaryText)
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.cardBackground, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            } else {
                ForEach(viewModel.recentDeepLinks) { record in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(record.route.title)
                            .font(.system(.headline, design: .rounded, weight: .semibold))
                            .foregroundStyle(theme.primaryText)

                        Text(AppDateFormatter.relativeString(from: record.openedAt))
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(theme.secondaryText)
                    }
                    .padding(18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(theme.cardBackground, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(theme.cardBorder, lineWidth: 1)
                    )
                }
            }
        }
    }
}
