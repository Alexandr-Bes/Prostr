//
//  IdeasComposerTextField.swift
//  Prostr
//
//  Created by Codex on 01.04.2026.
//

import SwiftUI

struct IdeasComposerTextField: View {
    let title: String
    @Binding var text: String
    let prompt: String
    let axis: Axis
    let errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "1A1A1A"))

            inputField

            if let errorMessage {
                Text(errorMessage)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color(hex: "FF4D4F"))
            }
        }
    }
}

private extension IdeasComposerTextField {
    var inputField: some View {
        TextField(
            "",
            text: $text,
            prompt: Text(prompt).foregroundStyle(Color(hex: "9B9C9E")),
            axis: axis
        )
        .font(.system(size: 16, weight: .regular, design: .rounded))
        .foregroundStyle(Color(hex: "1A1A1A"))
        .padding(.horizontal, 16)
        .padding(.vertical, axis == .vertical ? 14 : 16)
        .lineLimit(axis == .vertical ? 4...8 : 1...1)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(errorMessage == nil ? Color(hex: "BEC7CE") : Color(hex: "FF4D4F"), lineWidth: 1)
        )
    }
}
