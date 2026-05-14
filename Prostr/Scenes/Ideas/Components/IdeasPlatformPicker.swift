//
//  IdeasPlatformPicker.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import SwiftUI

struct IdeasPlatformPicker: View {
    let selectedPlatform: PlannerPlatform?
    let onSelect: (PlannerPlatform?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Platform Preview")
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "1A1A1A"))

            HStack(spacing: 10) {
                optionButton(title: "None", platform: nil)
                optionButton(title: "Instagram", platform: .instagram)
                optionButton(title: "LinkedIn", platform: .linkedin)
                optionButton(title: "TikTok", platform: .tiktok)
            }

            Text("Select a platform only if the card should show the media and social badges.")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(Color(hex: "6F6F74"))
        }
    }
}

private extension IdeasPlatformPicker {
    func optionButton(title: String, platform: PlannerPlatform?) -> some View {
        Button(title) {
            onSelect(platform)
        }
        .font(.system(size: 12, weight: .semibold, design: .rounded))
        .foregroundStyle(selectedPlatform == platform ? Color.white : Color(hex: "1A1A1A"))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(selectedPlatform == platform ? Color(hex: "2883C9") : Color.white)
        )
        .overlay(
            Capsule()
                .stroke(selectedPlatform == platform ? Color.clear : Color(hex: "BEC7CE"), lineWidth: 1)
        )
        .buttonStyle(.plain)
    }
}
