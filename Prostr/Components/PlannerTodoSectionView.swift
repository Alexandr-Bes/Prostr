//
//  PlannerTodoSectionView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import SwiftUI

struct PlannerTodoSectionView: View {
    @Environment(\.appTheme) private var theme

    @FocusState private var isComposerFocused: Bool
    @State private var isComposerVisible = false
    @State private var draftTitle = ""

    let items: [PlannerTodoItem]
    let onSeeAll: () -> Void
    let onToggle: (PlannerTodoItem) -> Void
    let onAdd: (String) -> Void

    init(
        items: [PlannerTodoItem],
        onSeeAll: @escaping () -> Void,
        onToggle: @escaping (PlannerTodoItem) -> Void = { _ in },
        onAdd: @escaping (String) -> Void = { _ in }
    ) {
        self.items = items
        self.onSeeAll = onSeeAll
        self.onToggle = onToggle
        self.onAdd = onAdd
    }

    var body: some View {
        PlannerSurfaceCard(backgroundColor: theme.cardBackground) {
            VStack(alignment: .leading, spacing: 18) {
                header

                if !items.isEmpty {
                    todoList
                }

                addItemSection
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button("Done") {
                    dismissComposer()
                }
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
            }
        }
        .animation(.snappy(duration: 0.22), value: isComposerVisible)
        .animation(.snappy(duration: 0.22), value: items.count)
    }
}

private extension PlannerTodoSectionView {
    var header: some View {
        HStack {
            Text("To-do list")
                .font(.system(.title3, design: .rounded, weight: .bold))
                .foregroundStyle(theme.primaryText)

            Spacer()

            Button("See all", action: onSeeAll)
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(theme.accentTint)
        }
    }

    var todoList: some View {
        VStack(alignment: .leading, spacing: 18) {
            ForEach(items) { item in
                PlannerTodoRowView(item: item) {
                    onToggle(item)
                }
            }
        }
    }

    @ViewBuilder
    var addItemSection: some View {
        if isComposerVisible {
            HStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(theme.accentTint)

                composerTextField

                if !normalizedDraftTitle.isEmpty {
                    Button("Add") {
                        submitNewItem()
                    }
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(theme.accentTint)
                }
            }
            .padding(.vertical, 6)
            .onAppear {
                isComposerFocused = true
            }
        } else {
            Button {
                isComposerVisible = true
                isComposerFocused = true
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))

                    Text("Add To-do List")
                        .font(.system(size: 16, weight: .medium, design: .rounded))
                }
                .foregroundStyle(theme.accentTint)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .buttonStyle(.plain)
        }
    }

    var normalizedDraftTitle: String {
        draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    @ViewBuilder
    var composerTextField: some View {
        let textField = TextField("Add To-do List", text: $draftTitle)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundStyle(theme.primaryText)
            .focused($isComposerFocused)
            .onSubmit(submitNewItem)

        #if os(iOS)
        textField
            .textInputAutocapitalization(.sentences)
            .submitLabel(.done)
        #else
        textField
        #endif
    }

    func submitNewItem() {
        let title = normalizedDraftTitle
        guard !title.isEmpty else {
            dismissComposer()
            return
        }

        onAdd(title)
        draftTitle = ""
        dismissComposer()
    }

    func dismissComposer() {
        isComposerFocused = false

        if normalizedDraftTitle.isEmpty {
            draftTitle = ""
            isComposerVisible = false
        }
    }
}
