//
//  EditPostChipEditorView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI

struct EditPostChipEditorView: View {
    let title: String
    let placeholder: String
    let prefix: String
    let backgroundColor: Color
    let textColor: Color

    @Binding var chips: [String]

    @State private var draftText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "8BA6C0"))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(chips, id: \.self) { chip in
                        chipView(chip)
                    }

                    TextField(placeholder, text: $draftText)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color(hex: "3E3E43"))
                        .textFieldStyle(.plain)
                        .frame(minWidth: 90)
                        .onSubmit(addDraftChip)
                }
                .padding(.vertical, 2)
            }
            .scrollClipDisabled()
        }
    }
}

private extension EditPostChipEditorView {
    func chipView(_ chip: String) -> some View {
        HStack(spacing: 6) {
            Text(chip)
                .font(.system(size: 14, weight: .medium, design: .rounded))

            Button {
                removeChip(chip)
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
            }
            .buttonStyle(.plain)
        }
        .foregroundStyle(textColor)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(backgroundColor, in: Capsule())
    }

    func addDraftChip() {
        let trimmedText = draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        let normalizedChip = normalized(trimmedText)

        guard !chips.contains(normalizedChip) else {
            draftText = ""
            return
        }

        chips.append(normalizedChip)
        draftText = ""
    }

    func removeChip(_ chip: String) {
        chips.removeAll { $0 == chip }
    }

    func normalized(_ value: String) -> String {
        if prefix.isEmpty {
            return value
        }

        return value.hasPrefix(prefix) ? value : prefix + value
    }
}
