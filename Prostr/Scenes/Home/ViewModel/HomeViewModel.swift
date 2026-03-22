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

    private var hasLoaded = false
    private var calendar = Calendar(identifier: .gregorian)

    private(set) var dashboard: PlannerDashboard?
    private(set) var visibleMonth: Date = .now
    private(set) var selectedDate: Date = .now
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var displayMode: PlannerHomeMode = .calendar

    init(plannerDashboardRepository: any PlannerDashboardRepositoryProtocol) {
        self.plannerDashboardRepository = plannerDashboardRepository
        self.calendar.firstWeekday = 1
    }

    init(previewDashboard: PlannerDashboard = PlannerDashboardMockData.dashboard) {
        self.plannerDashboardRepository = PlannerDashboardRepository(service: MockPlannerDashboardService())
        self.dashboard = previewDashboard
        self.visibleMonth = previewDashboard.visibleMonth
        self.selectedDate = previewDashboard.selectedDate
        self.hasLoaded = true
        self.calendar.firstWeekday = 1
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
            visibleMonth = dashboard.visibleMonth
            selectedDate = dashboard.selectedDate
            hasLoaded = true
        } catch {
            errorMessage = "The planner dashboard could not be loaded right now."
            Log.error(error)
        }
    }

    func selectDisplayMode(_ mode: PlannerHomeMode) {
        displayMode = mode
    }

    func shiftMonth(by value: Int) {
        guard let shiftedMonth = calendar.date(byAdding: .month, value: value, to: visibleMonth) else { return }
        visibleMonth = shiftedMonth

        guard !calendar.isDate(selectedDate, equalTo: shiftedMonth, toGranularity: .month) else { return }
        selectedDate = preferredSelectionDate(for: shiftedMonth)
    }

    func selectDay(_ day: Int) {
        var components = calendar.dateComponents([.year, .month], from: visibleMonth)
        components.day = day

        guard let selectedDate = calendar.date(from: components) else { return }
        self.selectedDate = selectedDate
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
        calendar.shortStandaloneWeekdaySymbols.map { String($0.prefix(2)) }
    }

    var cards: [PlannerContentCard] {
        dashboard?.cards ?? []
    }

    var todoItems: [PlannerTodoItem] {
        dashboard?.todoItems ?? []
    }

    var ideas: [PlannerIdea] {
        dashboard?.ideas ?? []
    }

    var calendarDays: [PlannerCalendarDay] {
        makeCalendarDays()
    }
}

private extension HomeViewModel {
    func preferredSelectionDate(for month: Date) -> Date {
        let preferredDay = dashboard?.markedDayNumbers.sorted().first ?? 1

        var components = calendar.dateComponents([.year, .month], from: month)
        components.day = preferredDay

        return calendar.date(from: components) ?? month
    }

    func makeCalendarDays() -> [PlannerCalendarDay] {
        guard let dashboard,
              let monthRange = calendar.range(of: .day, in: .month, for: visibleMonth),
              let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: visibleMonth)) else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: monthStart)
        let leadingSlots = (firstWeekday - calendar.firstWeekday + 7) % 7

        var days = Array(
            repeating: PlannerCalendarDay(
                id: UUID().uuidString,
                dayNumber: nil,
                isSelected: false,
                isMarked: false,
                isWithinDisplayedMonth: false
            ),
            count: leadingSlots
        )

        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
        let visibleComponents = calendar.dateComponents([.year, .month], from: visibleMonth)

        days += monthRange.map { day in
            let isSelected = selectedComponents.year == visibleComponents.year &&
                selectedComponents.month == visibleComponents.month &&
                selectedComponents.day == day

            return PlannerCalendarDay(
                id: "day-\(day)",
                dayNumber: day,
                isSelected: isSelected,
                isMarked: dashboard.markedDayNumbers.contains(day),
                isWithinDisplayedMonth: true
            )
        }

        let trailingSlots = (7 - (days.count % 7)) % 7
        days += Array(
            repeating: PlannerCalendarDay(
                id: UUID().uuidString,
                dayNumber: nil,
                isSelected: false,
                isMarked: false,
                isWithinDisplayedMonth: false
            ),
            count: trailingSlots
        )

        return days
    }
}
