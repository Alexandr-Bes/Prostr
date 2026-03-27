//
//  PlannerCardFilterBarView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 24.03.2026.
//

import SwiftUI

struct PlannerCardFilterBarView: View {
    @Binding var selection: PlannerCardFilter

    private let activeTint = Color(hex: "2883C9")

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(PlannerCardFilter.allCases) { filter in
                    filterChip(for: filter)
                }
            }
            .padding(.vertical, 2)
        }
    }
}

private extension PlannerCardFilterBarView {
    func filterChip(for filter: PlannerCardFilter) -> some View {
        let isSelected = selection == filter

        return Button {
            selection = filter
        } label: {
            Text(filter.title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium, design: .rounded))
                .foregroundStyle(isSelected ? Color.white : Color(hex: "1A1A1A"))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(chipBackground(isSelected: isSelected), in: Capsule())
                .overlay {
                    Capsule()
                        .stroke(activeTint, lineWidth: isSelected ? 0 : 1)
                }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(filter.title)
    }

    func chipBackground(isSelected: Bool) -> some ShapeStyle {
        isSelected ? AnyShapeStyle(activeTint) : AnyShapeStyle(Color.clear)
    }
}

#Preview {
    PlannerCardFilterBarView(selection: .constant(.scheduled))
}
