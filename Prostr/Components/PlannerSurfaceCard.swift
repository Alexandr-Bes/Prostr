//
//  PlannerSurfaceCard.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerSurfaceCard<Content: View>: View {
    @Environment(\.appTheme) private var theme

    private let cornerRadius: CGFloat
    private let contentPadding: CGFloat
    private let backgroundColor: Color?
    private let content: Content

    init(
        cornerRadius: CGFloat = 16,
        contentPadding: CGFloat = 24,
        backgroundColor: Color? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.contentPadding = contentPadding
        self.backgroundColor = backgroundColor
        self.content = content()
    }

    var body: some View {
        content
            .padding(contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                backgroundColor ?? theme.cardBackground,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(theme.cardBorder, lineWidth: 1)
            )
            .shadow(color: theme.cardShadow, radius: 18, y: 10)
    }
}

