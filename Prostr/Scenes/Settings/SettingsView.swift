//
//  SettingsView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppCore.self) private var appCore

    let viewModel: SettingsViewModel

    var body: some View {
        Form {
            Section("Appearance") {
                Picker("Theme Mode", selection: themeBinding) {
                    ForEach(ThemeMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

                Text("Theme selection is persisted through a dedicated service, while AppCore stays the single source of truth for the active mode.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }

            Section("Deep Link Preview") {
                ForEach(viewModel.previewRoutes, id: \.self) { route in
                    Button {
                        appCore.open(route: route)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(route.title)
                                .font(.headline)

                            Text(appCore.makeURL(for: route)?.absoluteString ?? "")
                                .font(.system(.caption, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Recent Routes") {
                if viewModel.recentDeepLinks.isEmpty {
                    Text("No deep links have been recorded yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.recentDeepLinks) { record in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(record.route.title)
                                .font(.headline)

                            Text(AppDateFormatter.relativeString(from: record.openedAt))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
        }
        .navigationTitle("Settings")
        .task {
            await viewModel.refreshHistory()
        }
        .onAppear {
            Task {
                await viewModel.refreshHistory()
            }
        }
    }
}

private extension SettingsView {
    var themeBinding: Binding<ThemeMode> {
        Binding(
            get: { viewModel.selectedThemeMode },
            set: { viewModel.updateThemeMode($0) }
        )
    }
}
