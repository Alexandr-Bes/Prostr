//
//  HomeView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppCore.self) private var appCore
    @Environment(\.appTheme) private var theme

    let viewModel: HomeViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                content
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
        .background(PlannerBackgroundView().ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                PlannerScreenHeaderView(
                    title: viewModel.screenTitle,
                    subtitle: viewModel.selectedDateTitle
                )
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button {
                } label: {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(theme.primaryText)
                }
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }
}

private extension HomeView {
    @ViewBuilder
    var content: some View {
        if viewModel.isLoading && viewModel.dashboard == nil {
            loadingStateView
        } else if let errorMessage = viewModel.errorMessage, viewModel.dashboard == nil {
            errorStateView(message: errorMessage)
        } else {
            plannerContent
        }
    }

    var plannerContent: some View {
        VStack(alignment: .leading, spacing: 24) {
            PlannerSegmentedControl(selection: displayModeBinding)

            if viewModel.displayMode == .calendar {
                PlannerCalendarView(
                    monthTitle: viewModel.monthTitle,
                    weekdaySymbols: viewModel.weekdaySymbols,
                    days: viewModel.calendarDays,
                    onPreviousMonth: { viewModel.shiftMonth(by: -1) },
                    onNextMonth: { viewModel.shiftMonth(by: 1) },
                    onSelectDay: viewModel.selectDay(_:)
                )
            } else {
                PlannerAgendaSectionView(cards: viewModel.cards)
            }

            PlannerTodoSectionView(
                items: viewModel.todoItems,
                onSeeAll: { appCore.selectedTab = .todo }
            )

            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Scheduled content")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)

//                    Spacer()
//
//                    Button("Ideas") {
//                        appCore.selectedTab = .ideas
//                    }
//                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
//                    .foregroundStyle(theme.accentTint)
                }

                ForEach(viewModel.cards) { card in
                    PlannerContentCardView(card: card)
                }
            }
        }
    }

    var displayModeBinding: Binding<PlannerHomeMode> {
        Binding(
            get: { viewModel.displayMode },
            set: { viewModel.displayMode = $0 }
        )
    }

    var loadingStateView: some View {
        PlannerSurfaceCard {
            HStack(spacing: 16) {
                ProgressView()
                    .tint(theme.accentTint)

                VStack(alignment: .leading, spacing: 6) {
                    Text("Loading planner")
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .foregroundStyle(theme.primaryText)

                    Text("Preparing your calendar, to-do items, and content cards.")
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundStyle(theme.secondaryText)
                }
            }
        }
    }

    func errorStateView(message: String) -> some View {
        PlannerSurfaceCard {
            VStack(alignment: .leading, spacing: 14) {
                Text("Something went wrong")
                    .font(.system(.headline, design: .rounded, weight: .bold))
                    .foregroundStyle(theme.primaryText)

                Text(message)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundStyle(theme.secondaryText)

                Button("Try again") {
                    Task {
                        await viewModel.reload()
                    }
                }
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(theme.inverseText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(theme.tabBarActiveBackground, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }
}


#Preview("Calendar Open") {
    let appCore = PreviewAppCore.make()

    NavigationStack {
        HomeView(viewModel: HomeViewModel(previewDashboard: PlannerDashboardMockData.dashboard))
    }
    .previewAppCore(appCore)
}

#Preview("List Mode") {
    let appCore = PreviewAppCore.make()
    let viewModel = HomeViewModel(previewDashboard: PlannerDashboardMockData.dashboard)
    viewModel.selectDisplayMode(.list)

    return NavigationStack {
        HomeView(viewModel: viewModel)
    }
    .previewAppCore(appCore)
}
