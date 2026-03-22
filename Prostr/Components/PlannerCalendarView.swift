//
//  PlannerCalendarView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct PlannerCalendarView: View {
    @Environment(\.appTheme) private var theme

    let monthTitle: String
    let weekdaySymbols: [String]
    let days: [PlannerCalendarDay]
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    let onSelectDay: (Int) -> Void

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 7)

    var body: some View {
        PlannerSurfaceCard {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calendar")
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(theme.tertiaryText)
                            .textCase(.uppercase)

                        Text(monthTitle)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                            .foregroundStyle(theme.primaryText)
                    }

                    Spacer()

                    HStack(spacing: 8) {
                        calendarButton(systemName: "chevron.left", action: onPreviousMonth)
                        calendarButton(systemName: "chevron.right", action: onNextMonth)
                    }
                }

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(weekdaySymbols, id: \.self) { symbol in
                        Text(symbol)
                            .font(.system(.caption, design: .rounded, weight: .bold))
                            .foregroundStyle(theme.tertiaryText)
                            .frame(maxWidth: .infinity)
                    }

                    ForEach(days) { day in
                        calendarDayCell(for: day)
                    }
                }
            }
        }
    }
}

private extension PlannerCalendarView {
    func calendarButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 12, weight: .bold))
                .foregroundStyle(theme.primaryText)
                .frame(width: 34, height: 34)
                .background(theme.secondaryCardBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    func calendarDayCell(for day: PlannerCalendarDay) -> some View {
        Group {
            if let dayNumber = day.dayNumber {
                Button {
                    onSelectDay(dayNumber)
                } label: {
                    VStack(spacing: 6) {
                        Text(String(dayNumber))
                            .font(.system(.subheadline, design: .rounded, weight: .semibold))
                            .foregroundStyle(dayTextColor(for: day))
                            .frame(maxWidth: .infinity, minHeight: 42)
                            .background(dayBackground(for: day))

                        Circle()
                            .fill(day.isMarked ? dayIndicatorColor(for: day) : .clear)
                            .frame(width: 6, height: 6)
                    }
                    .frame(height: 56)
                }
                .buttonStyle(.plain)
            } else {
                Color.clear
                    .frame(height: 56)
            }
        }
    }

    func dayTextColor(for day: PlannerCalendarDay) -> Color {
        if day.isSelected {
            return theme.inverseText
        }

        if day.isWithinDisplayedMonth {
            return theme.primaryText
        }

        return .clear
    }

    @ViewBuilder
    func dayBackground(for day: PlannerCalendarDay) -> some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(day.isSelected ? theme.tabBarActiveBackground : day.isMarked ? theme.accentSoft.opacity(0.8) : Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .stroke(day.isSelected ? Color.clear : theme.cardBorder, lineWidth: day.isMarked ? 0 : 1)
            )
    }

    func dayIndicatorColor(for day: PlannerCalendarDay) -> Color {
        day.isSelected ? theme.inverseText.opacity(0.75) : theme.accentTint
    }
}
