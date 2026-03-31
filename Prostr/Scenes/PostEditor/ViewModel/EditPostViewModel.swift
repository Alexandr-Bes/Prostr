//
//  EditPostViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 27.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class EditPostViewModel: Identifiable {
    var title: String
    var bodyText: String
    var selectedState: PlannerCardState
    var detailTags: [String]
    var hashtags: [String]
    var imageAssetName: String?
    var imageData: Data?
    var isSaving = false
    var errorMessage: String?

    let id: String
    let card: PlannerContentCard

    private let plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    private let preferredPostDate: Date?
    private let isNewPost: Bool

    init(
        card: PlannerContentCard,
        plannerDashboardRepository: any PlannerDashboardRepositoryProtocol,
        preferredPostDate: Date? = nil,
        isNewPost: Bool = false
    ) {
        self.id = card.id
        self.card = card
        self.plannerDashboardRepository = plannerDashboardRepository
        self.preferredPostDate = preferredPostDate
        self.isNewPost = isNewPost
        self.title = card.title
        self.bodyText = card.bodyText
        self.selectedState = card.state
        self.detailTags = !card.detailTags.isEmpty ? card.detailTags : card.tag.map { [$0] } ?? []
        self.hashtags = card.hashtags
        self.imageAssetName = card.imageAssetName
        self.imageData = card.imageData
    }

    convenience init(
        newPostFor date: Date,
        plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    ) {
        self.init(
            card: .makeDraft(postDate: date),
            plannerDashboardRepository: plannerDashboardRepository,
            preferredPostDate: date,
            isNewPost: true
        )
    }

    var screenTitle: String {
        isNewPost ? "New Post" : "Edit Post"
    }

    var postTypeTitle: String {
        card.postType.title
    }

    var postTypeSystemImage: String {
        card.postType.systemImage
    }

    var dateText: String? {
        guard selectedState != .draft else {
            return nil
        }

        let displayDate = card.postDate ?? preferredPostDate ?? card.createdAt
        return AppDateFormatter.plannerCardDateString(from: displayDate)
    }

    var selectedStateTitle: String {
        selectedState.title
    }

    var selectedStateIconAssetName: String {
        selectedState.iconAssetName
    }

    var selectedStatePalette: PlannerContentCardPalette {
        selectedState.palette
    }

    var showsScheduledDateIcon: Bool {
        selectedState == .scheduled
    }

    var canDeletePost: Bool {
        !isNewPost
    }

    var currentImageAssetName: String? {
        imageAssetName
    }

    var currentImageData: Data? {
        imageData
    }

    func applySelectedPhotoData(_ data: Data?) {
        guard let data else { return }

        imageData = data
        imageAssetName = nil
        errorMessage = nil
    }

    func handlePhotoLoadingError(_ error: any Error) {
        errorMessage = "The selected image could not be loaded."
        Log.error(error)
    }

    func removePhoto() {
        imageData = nil
        imageAssetName = nil
    }

    func save() async -> Bool {
        let normalizedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedBody = bodyText.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !normalizedTitle.isEmpty else {
            errorMessage = "Title can’t be empty."
            return false
        }

        guard !normalizedBody.isEmpty else {
            errorMessage = "Description can’t be empty."
            return false
        }

        isSaving = true
        errorMessage = nil

        defer {
            isSaving = false
        }

        let updatedCard = card.updating(
            title: normalizedTitle,
            bodyText: normalizedBody,
            state: selectedState,
            imageAssetName: imageAssetName,
            imageData: imageData,
            detailTags: detailTags,
            hashtags: hashtags,
            fallbackPostDate: preferredPostDate
        )

        do {
            if isNewPost {
                _ = try await plannerDashboardRepository.createContentCard(updatedCard)
            } else {
                _ = try await plannerDashboardRepository.updateContentCard(updatedCard)
            }
            return true
        } catch {
            errorMessage = "The post could not be saved right now."
            Log.error(error)
            return false
        }
    }

    func delete() async -> Bool {
        guard canDeletePost else {
            return false
        }

        isSaving = true
        errorMessage = nil

        defer {
            isSaving = false
        }

        do {
            _ = try await plannerDashboardRepository.deleteContentCard(id: card.id)
            return true
        } catch {
            errorMessage = "The post could not be deleted right now."
            Log.error(error)
            return false
        }
    }
}
