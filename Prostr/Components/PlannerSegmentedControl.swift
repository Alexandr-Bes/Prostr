//
//  PlannerSegmentedControl.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct PlannerSegmentedControl: View {
    @Environment(\.appTheme) private var theme

    @Binding var selection: PlannerHomeMode

    var body: some View {
        Picker("Planner mode", selection: $selection) {
            ForEach(PlannerHomeMode.allCases) { mode in
                Text(mode.title)
                    .tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .tint(theme.tabBarActiveBackground)
    }
}
