//
//  EditPostMetadataRowView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

struct EditPostMetadataRowView: View {
    let avatarAssetName: String?
    let title: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 10) {
            if let avatarAssetName {
                Image(avatarAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .accessibilityHidden(true)
            }

            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .medium))

                Text(title)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
            }
            .foregroundStyle(Color(hex: "4D5D6B"))
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(Color(hex: "EAF4FF"), in: Capsule())
        }
    }
}
