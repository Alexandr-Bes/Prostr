//
//  PlannerBackgroundView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerBackgroundView: View {
    @Environment(\.appTheme) private var theme

    var body: some View {
        ZStack {
            Rectangle()
                .fill(theme.background)
//            LinearGradient(
//                colors: [theme.canvasTop, theme.canvasBottom],
//                startPoint: .topLeading,
//                endPoint: .bottomTrailing
//            )

//            Circle()
//                .fill(theme.ambientGlowTop)
//                .frame(width: 260, height: 260)
//                .blur(radius: 12)
//                .offset(x: -120, y: -220)

//            Ellipse()
//                .fill(theme.ambientGlowBottom)
//                .frame(width: 360, height: 300)
//                .blur(radius: 36)
//                .offset(x: 160, y: 250)
        }
    }
}

#Preview {
    PlannerBackgroundView()
}
