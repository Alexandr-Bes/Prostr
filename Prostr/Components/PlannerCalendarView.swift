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
    let weeks: [[PlannerCalendarDay]]
    let displayMode: PlannerCalendarDisplayMode
    let onPreviousPeriod: () -> Void
    let onNextPeriod: () -> Void
    let onSelectDay: (Date) -> Void
    let onToggleDisplayMode: () -> Void

    private let selectionTint = Color(hex: "3485CA")

    var body: some View {
        VStack(spacing: 0) {
            header
            weekdayHeader
            weeksGrid
            collapseHandle
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
        .padding(.bottom, 10)
        .background(theme.cardBackground, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(theme.cardBorder, lineWidth: 1)
        )
        .shadow(color: theme.cardShadow, radius: 18, y: 10)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .simultaneousGesture(horizontalSwipeGesture)
        .animation(.snappy(duration: 0.22), value: weeks)
        .animation(.snappy(duration: 0.22), value: displayMode)
    }
}

private extension PlannerCalendarView {
    var header: some View {
        HStack {
            navigationButton(systemName: "chevron.left", action: onPreviousPeriod)

            Spacer(minLength: 16)

            Text(monthTitle)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .foregroundStyle(theme.primaryText)

            Spacer(minLength: 16)

            navigationButton(systemName: "chevron.right", action: onNextPeriod)
        }
        .padding(.bottom, 10)
    }

    var weekdayHeader: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.tertiaryText)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.bottom, 10)
    }

    var weeksGrid: some View {
        VStack(spacing: displayMode == .month ? 12 : 10) {
            ForEach(Array(weeks.enumerated()), id: \.offset) { weekEntry in
                HStack(spacing: 0) {
                    ForEach(weekEntry.element) { day in
                        dayCell(for: day)
                    }
                }
            }
        }
    }

    var collapseHandle: some View {
        Capsule()
            .fill(theme.cardBorder.opacity(0.9))
            .frame(width: 34, height: 4)
            .padding(.top, 14)
            .contentShape(Rectangle())
            .onTapGesture(perform: onToggleDisplayMode)
            .gesture(verticalToggleGesture)
    }

    func navigationButton(systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(theme.primaryText)
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.plain)
    }

    func dayCell(for day: PlannerCalendarDay) -> some View {
        Button {
            onSelectDay(day.date)
        } label: {
            VStack(spacing: 5) {
                Text(String(day.dayNumber))
                    .font(.system(.body, design: .rounded, weight: .medium))
                    .foregroundStyle(dayTextColor(for: day))
                    .frame(width: 32, height: 32)
                    .background(day.isSelected ? selectionTint : Color.clear, in: Circle())

                markersRow(for: day)
                    .frame(height: 8)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 0)
        }
        .buttonStyle(.plain)
    }

    func markersRow(for day: PlannerCalendarDay) -> some View {
        HStack(spacing: 4) {
            if day.markers.isEmpty {
                Color.clear
                    .frame(width: 8, height: 8)
            } else {
                ForEach(day.markers, id: \.self) { marker in
                    markerDot(for: marker)
                }
            }
        }
    }

    func markerDot(for marker: PlannerCalendarMarker) -> some View {
        Circle()
            .strokeBorder(selectionTint, lineWidth: marker == .planned ? 1.2 : 0)
            .background(
                Circle()
                    .fill(marker == .scheduled ? selectionTint : Color.clear)
            )
            .frame(width: 5, height: 5)
    }

    func dayTextColor(for day: PlannerCalendarDay) -> Color {
        if day.isSelected {
            return .white
        }

        return day.isWithinDisplayedMonth ? theme.primaryText : theme.tertiaryText
    }

    var horizontalSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 18)
            .onEnded { value in
                guard abs(value.translation.width) > abs(value.translation.height),
                      abs(value.translation.width) > 30 else {
                    return
                }

                if value.translation.width < 0 {
                    onNextPeriod()
                } else {
                    onPreviousPeriod()
                }
            }
    }

    var verticalToggleGesture: some Gesture {
        DragGesture(minimumDistance: 10)
            .onEnded { value in
                guard abs(value.translation.height) > abs(value.translation.width),
                      abs(value.translation.height) > 10 else {
                    return
                }

                onToggleDisplayMode()
            }
    }
}
