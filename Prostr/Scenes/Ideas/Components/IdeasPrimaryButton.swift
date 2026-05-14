//
//  IdeasPrimaryButton.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import SwiftUI

struct IdeasPrimaryButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(title, systemImage: systemImage, action: action)
            .font(.system(size: 14, weight: .medium, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(Color(hex: "2883C9"), in: Capsule())
            .buttonStyle(.plain)
    }
}
