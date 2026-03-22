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

    private(set) var dashboard: PlannerDashboard?
    private(set) var visibleMonth: Date
    private(set) var selectedDate: Date
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    private(set) var calendarDisplayMode: PlannerCalendarDisplayMode = .month
    var displayMode: PlannerHomeMode = .calendar

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        let calendarBuilder = PlannerCalendarBuilder()
        let today = calendarBuilder.normalizedDay(.now)

        self.plannerDashboardRepository = plannerDashboardRepository
        self.calendarBuilder = calendarBuilder
        self.visibleMonth = calendarBuilder.startOfMonth(for: today)
        self.selectedDate = today
        self.retainedSelectedDate = today
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

    var screenTitle: String {
        dashboard?.screenTitle ?? "Plan"
    }

    var selectedDateTitle: String {
        AppDateFormatter.plannerHeaderString(from: selectedDate)
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
}
