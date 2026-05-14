//
//  EditPostChipRowView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

struct EditPostChipRowView: View {
    let chips: [String]
    let backgroundColor: Color
    let textColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(chips, id: \.self) { chip in
                    Text(chip)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(textColor)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(backgroundColor, in: Capsule())
                }
            }
        }
        .scrollClipDisabled()
    }
}
