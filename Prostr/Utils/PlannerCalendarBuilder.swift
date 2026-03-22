//
//  PlannerCalendarBuilder.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 22.03.2026.
//

import Foundation

struct PlannerCalendarBuilder {
    let calendar: Calendar

    init(calendar: Calendar = PlannerCalendarBuilder.makeCalendar()) {
        self.calendar = calendar
    }

    func normalizedDay(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    func startOfMonth(for date: Date) -> Date {
        let normalizedDate = normalizedDay(date)
        let components = calendar.dateComponents([.year, .month], from: normalizedDate)
        return calendar.date(from: components) ?? normalizedDate
    }

    func shiftMonth(_ date: Date, by value: Int) -> Date {
        let monthStart = startOfMonth(for: date)
        let shiftedMonth = calendar.date(byAdding: .month, value: value, to: monthStart) ?? monthStart
        return startOfMonth(for: shiftedMonth)
    }

    func shiftWeek(_ date: Date, by value: Int) -> Date {
        let normalizedDate = normalizedDay(date)
        let shiftedDate = calendar.date(byAdding: .day, value: value * 7, to: normalizedDate) ?? normalizedDate
        return normalizedDay(shiftedDate)
    }

    func matchingDay(in month: Date, preferredDayFrom date: Date) -> Date {
        let monthStart = startOfMonth(for: month)
        let preferredDay = calendar.component(.day, from: normalizedDay(date))
        let maxDay = calendar.range(of: .day, in: .month, for: monthStart)?.count ?? preferredDay

        var components = calendar.dateComponents([.year, .month], from: monthStart)
        components.day = min(preferredDay, maxDay)

        return normalizedDay(calendar.date(from: components) ?? monthStart)
    }

    func weekdaySymbols() -> [String] {
        let symbols = calendar.shortStandaloneWeekdaySymbols
        let shift = max(calendar.firstWeekday - 1, 0)
        return Array(symbols[shift...]) + Array(symbols[..<shift])
    }

    func makeWeeks(
        visibleMonth: Date,
        selectedDate: Date,
        cards: [PlannerContentCard]
    ) -> [[PlannerCalendarDay]] {
        let monthStart = startOfMonth(for: visibleMonth)

        guard let monthInterval = calendar.dateInterval(of: .month, for: monthStart),
              let monthLastDay = calendar.date(byAdding: .day, value: -1, to: monthInterval.end),
              let firstDisplayedDate = calendar.dateInterval(of: .weekOfYear, for: monthInterval.start)?.start,
              let lastWeekStart = calendar.dateInterval(of: .weekOfYear, for: monthLastDay)?.start,
              let lastDisplayedDate = calendar.date(byAdding: .day, value: 6, to: lastWeekStart) else {
            return []
        }

        var displayedDates: [Date] = []
        var currentDate = firstDisplayedDate

        while currentDate <= lastDisplayedDate {
            displayedDates.append(normalizedDay(currentDate))
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }

        let days = displayedDates.map { date in
            PlannerCalendarDay(
                id: String(Int(date.timeIntervalSince1970)),
                date: date,
                dayNumber: calendar.component(.day, from: date),
                isSelected: isSameDay(date, selectedDate),
                isWithinDisplayedMonth: calendar.isDate(date, equalTo: monthStart, toGranularity: .month),
                markers: markers(for: date, cards: cards)
            )
        }

        return stride(from: 0, to: days.count, by: 7).map { index in
            Array(days[index..<min(index + 7, days.count)])
        }
    }

    func week(
        containing selectedDate: Date,
        in weeks: [[PlannerCalendarDay]]
    ) -> [PlannerCalendarDay] {
        weeks.first(where: { week in
            week.contains(where: { isSameDay($0.date, selectedDate) })
        }) ?? weeks.first ?? []
    }

    func isSameDay(_ lhs: Date, _ rhs: Date) -> Bool {
        calendar.isDate(lhs, inSameDayAs: rhs)
    }

    private func markers(
        for date: Date,
        cards: [PlannerContentCard]
    ) -> [PlannerCalendarMarker] {
        let markers = Set(
            cards.compactMap { card -> PlannerCalendarMarker? in
                guard let marker = card.calendarMarker,
                      isSameDay(card.effectiveDisplayDate, date) else {
                    return nil
                }

                return marker
            }
        )

        return markers.sorted { $0.sortOrder < $1.sortOrder }
    }
}

private extension PlannerCalendarBuilder {
    static func makeCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        return calendar
    }
}
