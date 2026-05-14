//
//  AuthSceneContainer.swift
//  Prostr
//
//  Created by Codex on 31.03.2026.
//

import SwiftUI

struct AuthSceneContainer<Content: View, Footer: View>: View {
    @Environment(\.colorScheme) private var colorScheme

    private let title: String
    private let backAction: () -> Void
    private let content: Content
    private let footer: Footer

    init(
        title: String,
        backAction: @escaping () -> Void,
        @ViewBuilder content: () -> Content,
        @ViewBuilder footer: () -> Footer
    ) {
        self.title = title
        self.backAction = backAction
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        let palette = AuthPalette(colorScheme: colorScheme)

        ScrollView(showsIndicators: false) {
            VStack(spacing: 36) {
                HStack {
                    AuthBackButton(action: backAction)
                    Spacer()
                }

                VStack(spacing: 32) {
                    Text(title)
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(palette.primaryText)
                        .frame(maxWidth: .infinity)

                    content
                }

                footer
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 32)
        }
        .scrollDismissesKeyboard(.interactively)
        .simultaneousGesture(
            TapGesture().onEnded {
                dismissKeyboard()
            }
        )
        .background(palette.background.ignoresSafeArea())
    }
}
