//
//  EditPostStatePickerView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

struct EditPostStatePickerView: View {
    @Binding var selection: PlannerCardState

    private let activeTint = Color(hex: "2883C9")

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach([PlannerCardState.draft, .planned, .scheduled], id: \.self) { state in
                    chip(for: state)
                }
            }
        }
        .scrollClipDisabled()
    }
}

private extension EditPostStatePickerView {
    func chip(for state: PlannerCardState) -> some View {
        let isSelected = selection == state

        return Button {
            selection = state
        } label: {
            HStack(spacing: 6) {
                Image(state.iconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
                    .accessibilityHidden(true)

                Text(state.title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium, design: .rounded))
            }
            .foregroundStyle(isSelected ? Color.white : Color(hex: "1A1A1A"))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(isSelected ? AnyShapeStyle(activeTint) : AnyShapeStyle(Color.clear), in: Capsule())
            .overlay {
                Capsule()
                    .stroke(activeTint, lineWidth: isSelected ? 0 : 1)
            }
        }
        .buttonStyle(.plain)
    }
}
