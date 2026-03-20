//
//  TabsView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct TabsView: View {
    @Environment(AppCore.self) private var appCore

    @State private var homeViewModel: HomeViewModel
    @State private var settingsViewModel: SettingsViewModel

    init(appCore: AppCore) {
        _homeViewModel = State(
            wrappedValue: HomeViewModel(
                homeRepository: appCore.repositories.homeRepository,
                deepLinkHistoryRepository: appCore.repositories.deepLinkHistoryRepository
            )
        )

        _settingsViewModel = State(
            wrappedValue: SettingsViewModel(
                initialThemeMode: appCore.selectedThemeMode,
                deepLinkHistoryRepository: appCore.repositories.deepLinkHistoryRepository,
                onThemeModeChange: { mode in
                    appCore.updateThemeMode(mode)
                }
            )
        )
    }

    var body: some View {
        TabView(selection: selectionBinding) {
            Tab(AppTab.home.title, systemImage: AppTab.home.systemImage, value: AppTab.home) {
                NavigationStack(path: homePathBinding) {
                    HomeView(viewModel: homeViewModel)
                        .navigationDestination(for: String.self) { featureID in
                            HomeFeatureDetailView(featureID: featureID, viewModel: homeViewModel)
                        }
                }
            }

            Tab(AppTab.settings.title, systemImage: AppTab.settings.systemImage, value: AppTab.settings) {
                NavigationStack {
                    SettingsView(viewModel: settingsViewModel)
                }
            }
        }
    }
}

private extension TabsView {
    var selectionBinding: Binding<AppTab> {
        Binding(
            get: { appCore.selectedTab },
            set: { appCore.selectedTab = $0 }
        )
    }

    var homePathBinding: Binding<[String]> {
        Binding(
            get: { appCore.homePath },
            set: { appCore.homePath = $0 }
        )
    }
}
