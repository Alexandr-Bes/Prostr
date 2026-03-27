//
//  HomeViewModel.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import Foundation
import Observation

@Observable
@MainActor
final class HomeViewModel {
    private let plannerDashboardRepository: any PlannerDashboardRepositoryProtocol
    private let calendarBuilder: PlannerCalendarBuilder

    private var hasLoaded = false
    private var retainedSelectedDate: Date
    private var dashboardUpdatesTask: Task<Void, Never>?

    private(set) var dashboard: PlannerDashboard?
    private(set) var visibleMonth: Date
    private(set) var selectedDate: Date
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var calendarDisplayMode: PlannerCalendarDisplayMode = .month
    var displayMode: PlannerHomeMode = .calendar
    var selectedCardFilter: PlannerCardFilter = .all

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        let calendarBuilder = PlannerCalendarBuilder()
        let today = calendarBuilder.normalizedDay(.now)

        self.plannerDashboardRepository = plannerDashboardRepository
        self.calendarBuilder = calendarBuilder
        self.visibleMonth = calendarBuilder.startOfMonth(for: today)
        self.selectedDate = today
        self.retainedSelectedDate = today

        observeDashboardUpdates()
    }

    init(previewDashboard: PlannerDashboard) {
        let calendarBuilder = PlannerCalendarBuilder()
        let initialSelection = calendarBuilder.normalizedDay(previewDashboard.selectedDate)

        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.calendarBuilder = calendarBuilder
        self.dashboard = previewDashboard
        self.visibleMonth = calendarBuilder.startOfMonth(for: initialSelection)
        self.selectedDate = initialSelection
        self.retainedSelectedDate = initialSelection
        self.hasLoaded = true
    }

    func loadIfNeeded() async {
        guard !hasLoaded else { return }
        await reload()
    }

    func reload() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            let dashboard = try await plannerDashboardRepository.fetchDashboard()
            self.dashboard = dashboard

            let preferredSelection = retainedSelectedDate
            selectedDate = preferredSelection
            visibleMonth = calendarBuilder.startOfMonth(for: preferredSelection)
            hasLoaded = true
        } catch {
            errorMessage = "The planner dashboard could not be loaded right now."
            Log.error(error)
        }
    }

    func selectDisplayMode(_ mode: PlannerHomeMode) {
        displayMode = mode
    }

    func shiftVisiblePeriod(by value: Int) {
        switch calendarDisplayMode {
        case .month:
            shiftMonth(by: value)
        case .week:
            shiftWeek(by: value)
        }
    }

    func selectDate(_ date: Date) {
        applySelection(date)
    }

    func applyDeepLink(date: Date) {
        applySelection(date)
    }

    func toggleCalendarDisplayMode() {
        calendarDisplayMode.toggle()
    }

    func selectCardFilter(_ filter: PlannerCardFilter) {
        selectedCardFilter = filter
    }

    func addTodoItem(title: String) async {
        do {
            _ = try await plannerDashboardRepository.addTodoItem(
                title: title,
                dueDate: selectedDate
            )
        } catch {
            Log.error(error)
        }
    }

    func toggleTodoItem(id: String) async {
        do {
            _ = try await plannerDashboardRepository.toggleTodoItem(id: id)
        } catch {
            Log.error(error)
        }
    }

    var screenTitle: String {
        dashboard?.screenTitle ?? "Plan"
    }

    var selectedDateTitle: String {
        AppDateFormatter.plannerHeaderString(from: selectedDate)
    }

    var navigationTitle: String {
        displayMode == .list ? "Planner" : screenTitle
    }

    var navigationSubtitle: String {
        displayMode == .list ? "" : selectedDateTitle
    }

    var monthTitle: String {
        AppDateFormatter.monthTitle(from: visibleMonth)
    }

    var weekdaySymbols: [String] {
        calendarBuilder.weekdaySymbols()
    }

    var cards: [PlannerContentCard] {
        allCards.filter { calendarBuilder.isSameDay($0.effectiveDisplayDate, selectedDate) }
    }

    var todoItems: [PlannerTodoItem] {
        (dashboard?.todoItems ?? []).filter { calendarBuilder.isSameDay($0.dueDate, selectedDate) }
    }

    var ideas: [PlannerIdea] {
        dashboard?.ideas ?? []
    }

    var listSections: [PlannerCardListSection] {
        let cards = filteredListCards
        guard !cards.isEmpty else { return [] }

        switch selectedCardFilter {
        case .all:
            return draftSections(from: cards) + datedSections(from: cards.filter { $0.state != .draft })

        case .drafts:
            return draftSections(from: cards)

        case .planned, .scheduled:
            return datedSections(from: cards)
        }
    }

    var calendarWeeks: [[PlannerCalendarDay]] {
        let weeks = calendarBuilder.makeWeeks(
            visibleMonth: visibleMonth,
            selectedDate: selectedDate,
            cards: allCards
        )

        guard calendarDisplayMode == .week else {
            return weeks
        }

        let selectedWeek = calendarBuilder.week(containing: selectedDate, in: weeks)
        return selectedWeek.isEmpty ? weeks : [selectedWeek]
    }
}

private extension HomeViewModel {
    var allCards: [PlannerContentCard] {
        dashboard?.cards ?? []
    }

    var filteredListCards: [PlannerContentCard] {
        allCards.filter { selectedCardFilter.matches($0) }
    }

    func shiftMonth(by value: Int) {
        let shiftedMonth = calendarBuilder.shiftMonth(visibleMonth, by: value)
        visibleMonth = shiftedMonth

        let matchedDate = calendarBuilder.matchingDay(in: shiftedMonth, preferredDayFrom: selectedDate)
        selectedDate = matchedDate
        retainedSelectedDate = matchedDate
    }

    func shiftWeek(by value: Int) {
        let shiftedDate = calendarBuilder.shiftWeek(selectedDate, by: value)
        applySelection(shiftedDate)
    }

    func applySelection(_ date: Date) {
        let normalizedDate = calendarBuilder.normalizedDay(date)
        selectedDate = normalizedDate
        retainedSelectedDate = normalizedDate
        visibleMonth = calendarBuilder.startOfMonth(for: normalizedDate)
    }

    func observeDashboardUpdates() {
        dashboardUpdatesTask = Task { [weak self] in
            guard let self else { return }

            let updates = self.plannerDashboardRepository.dashboardUpdates()

            for await dashboard in updates {
                self.receiveDashboardUpdate(dashboard)
            }
        }
    }

    func receiveDashboardUpdate(_ dashboard: PlannerDashboard) {
        self.dashboard = dashboard

        guard !hasLoaded else { return }

        let preferredSelection = retainedSelectedDate
        selectedDate = preferredSelection
        visibleMonth = calendarBuilder.startOfMonth(for: preferredSelection)
        hasLoaded = true
    }

    func draftSections(from cards: [PlannerContentCard]) -> [PlannerCardListSection] {
        let drafts = cards
            .filter { $0.state == .draft }
            .sorted(by: sortDraftCards(_:_:))

        guard !drafts.isEmpty else {
            return []
        }

        return [
            PlannerCardListSection(
                id: "drafts",
                title: nil,
                cards: drafts
            )
        ]
    }

    func datedSections(from cards: [PlannerContentCard]) -> [PlannerCardListSection] {
        let groupedCards = Dictionary(grouping: cards) { card in
            calendarBuilder.normalizedDay(card.effectiveDisplayDate)
        }

        return groupedCards.keys
            .sorted()
            .compactMap { date in
                guard let cards = groupedCards[date] else {
                    return nil
                }

                return PlannerCardListSection(
                    id: AppDateFormatter.plannerDeepLinkDateString(from: date),
                    title: AppDateFormatter.plannerHeaderString(from: date),
                    cards: cards.sorted(by: sortDatedCards(_:_:))
                )
            }
    }

    func sortDraftCards(_ left: PlannerContentCard, _ right: PlannerContentCard) -> Bool {
        if left.createdAt != right.createdAt {
            return left.createdAt > right.createdAt
        }

        return left.title.localizedCaseInsensitiveCompare(right.title) == .orderedAscending
    }

    func sortDatedCards(_ left: PlannerContentCard, _ right: PlannerContentCard) -> Bool {
        if left.effectiveDisplayDate != right.effectiveDisplayDate {
            return left.effectiveDisplayDate < right.effectiveDisplayDate
        }

        let leftStatePriority = stateSortPriority(for: left.state)
        let rightStatePriority = stateSortPriority(for: right.state)

        if leftStatePriority != rightStatePriority {
            return leftStatePriority < rightStatePriority
        }

        return left.title.localizedCaseInsensitiveCompare(right.title) == .orderedAscending
    }

    func stateSortPriority(for state: PlannerCardState) -> Int {
        switch state {
        case .planned:
            return 0
        case .scheduled:
            return 1
        case .draft:
            return 2
        }
    }
}
