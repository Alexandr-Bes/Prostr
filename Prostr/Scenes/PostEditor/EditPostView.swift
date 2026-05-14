//
//  EditPostView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import SwiftUI
import PhotosUI

struct EditPostView: View {
    @Environment(\.dismiss) private var dismiss

    @Bindable var viewModel: EditPostViewModel
    @State private var selectedPhotoItem: PhotosPickerItem?
    @State private var showsDeleteConfirmation = false

    private let contentPadding: CGFloat = 16

    var body: some View {
        VStack(spacing: 0) {
            header

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    statusRow

                    EditPostStatePickerView(selection: $viewModel.selectedState)

                    EditPostMetadataRowView(
                        avatarAssetName: viewModel.card.platform.avatarAssetName,
                        title: viewModel.postTypeTitle,
                        systemImage: viewModel.postTypeSystemImage
                    )

                    TextField("Post title", text: $viewModel.title, axis: .vertical)
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Color(hex: "1A1A1A"))
                        .textFieldStyle(.plain)
                        .lineLimit(2...3)

                    EditPostChipEditorView(
                        title: "Tags",
                        placeholder: "Add tag",
                        prefix: "",
                        backgroundColor: Color(hex: "EAF5EE"),
                        textColor: Color(hex: "495A57"),
                        chips: $viewModel.detailTags
                    )

                    TextEditor(text: $viewModel.bodyText)
                        .font(.system(size: 16, weight: .regular, design: .rounded))
                        .foregroundStyle(Color(hex: "3E3E43"))
                        .scrollContentBackground(.hidden)
                        .frame(minHeight: 170)
                        .padding(.horizontal, 2)

                    EditPostChipEditorView(
                        title: "Hashtags",
                        placeholder: "Add hashtag",
                        prefix: "#",
                        backgroundColor: Color(hex: "EEF6FF"),
                        textColor: Color(hex: "8BB3D9"),
                        chips: $viewModel.hashtags
                    )

                    mediaContent

                    mediaActions

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.system(size: 13, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.red)
                    }
                }
                .padding(.horizontal, contentPadding)
                .padding(.top, 16)
                .padding(.bottom, 28)
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color.white.ignoresSafeArea())
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(32)
        .onChange(of: selectedPhotoItem) { _, newItem in
            Task {
                await loadSelectedPhoto(from: newItem)
            }
        }
        .safeAreaInset(edge: .bottom) {
            saveButton
        }
        .confirmationDialog(
            "Delete this post?",
            isPresented: $showsDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Post", role: .destructive) {
                Task {
                    if await viewModel.delete() {
                        dismiss()
                    }
                }
            }

            Button("Cancel", role: .cancel) {
            }
        } message: {
            Text("This action removes the post from your planner.")
        }
    }
}

private extension EditPostView {
    var header: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundStyle(Color(hex: "BEC7CE"))
                    .frame(width: 44, height: 44)
            }

            Spacer()

            Text(viewModel.screenTitle)
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "1A1A1A"))

            Spacer()

            trailingHeaderAction
        }
        .padding(.horizontal, 8)
        .padding(.top, 8)
    }

    @ViewBuilder
    var trailingHeaderAction: some View {
        if viewModel.canDeletePost {
            Menu {
                Button("Delete Post", role: .destructive) {
                    showsDeleteConfirmation = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(Color(hex: "1A1A1A"))
                    .frame(width: 44, height: 44)
            }
        } else {
            Color.clear
                .frame(width: 44, height: 44)
        }
    }

    var statusRow: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Image(viewModel.selectedStateIconAssetName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .accessibilityHidden(true)

                Text(viewModel.selectedStateTitle)
                    .font(.system(size: 12, weight: .semibold, design: .rounded))
            }
            .foregroundStyle(viewModel.selectedStatePalette.statusTextColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(viewModel.selectedStatePalette.statusBackgroundColor, in: Capsule())

            Spacer()

            if let dateText = viewModel.dateText {
                HStack(spacing: 6) {
                    if viewModel.showsScheduledDateIcon {
                        Image("scheduledDateIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .accessibilityHidden(true)
                    }

                    Text(dateText)
                        .lineLimit(1)
                }
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundStyle(viewModel.selectedStatePalette.metaTextColor)
            }
        }
    }

    var mediaContent: some View {
        PlannerPostMediaView(
            assetName: viewModel.currentImageAssetName,
            imageData: viewModel.currentImageData
        ) {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            viewModel.selectedState.palette.placeholderTopColor,
                            viewModel.selectedState.palette.placeholderBottomColor
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Image(systemName: "photo")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(viewModel.selectedState.palette.metaTextColor.opacity(0.7))
                }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 242)
        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
    }

    var mediaActions: some View {
        HStack(spacing: 12) {
            PhotosPicker(selection: $selectedPhotoItem, matching: .images) {
                Label("Change picture", systemImage: "photo.badge.plus")
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(hex: "2883C9"))
            }

            Spacer()

            if viewModel.currentImageAssetName != nil || viewModel.currentImageData != nil {
                Button("Remove") {
                    viewModel.removePhoto()
                }
                .font(.system(size: 15, weight: .semibold, design: .rounded))
                .foregroundStyle(Color(hex: "BEC7CE"))
            }
        }
    }

    var saveButton: some View {
        Button {
            Task {
                if await viewModel.save() {
                    dismiss()
                }
            }
        } label: {
            ZStack {
                Text(viewModel.isSaving ? "Saving..." : "Save")
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color(hex: "3B4450"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color(hex: "EFF7FF"), in: Capsule())
                    .overlay {
                        Capsule()
                            .stroke(Color(hex: "4DA4F2"), lineWidth: 1.5)
                    }

                if viewModel.isSaving {
                    ProgressView()
                        .tint(Color(hex: "3B4450"))
                }
                }
                .opacity(viewModel.isSaving ? 0.94 : 1)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isSaving)
        .padding(.horizontal, contentPadding)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(Color.white)
    }

    func loadSelectedPhoto(from item: PhotosPickerItem?) async {
        guard let item else { return }

        do {
            let data = try await item.loadTransferable(type: Data.self)
            viewModel.applySelectedPhotoData(data)
        } catch {
            viewModel.handlePhotoLoadingError(error)
        }
    }
}

#Preview {
    EditPostView(
        viewModel: EditPostViewModel(
            card: PlannerDashboardMockData.dashboard.cards[1],
            plannerDashboardRepository: PlannerDashboardRepository(service: MockPlannerDashboardService())
        )
    )
}
