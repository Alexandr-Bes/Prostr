//
//  TabsView.swift
//  Prostr
//
//  Created by AlexBezkopylnyi on 20.03.2026.
//

import SwiftUI

struct TabsView: View {
    @Environment(AppCore.self) private var appCore

    @State private var homeViewModel: HomeViewModel
    @State private var todoViewModel: TodoViewModel
    @State private var ideasViewModel: IdeasViewModel

    init(appCore: AppCore) {
        _homeViewModel = State(
            wrappedValue: HomeViewModel(plannerDashboardRepository: appCore.repositories.plannerDashboardRepository)
        )

        _todoViewModel = State(
            wrappedValue: TodoViewModel(plannerDashboardRepository: appCore.repositories.plannerDashboardRepository)
        )

        _ideasViewModel = State(
            wrappedValue: IdeasViewModel(plannerDashboardRepository: appCore.repositories.plannerDashboardRepository)
        )
    }

    var body: some View {
        currentTabView
            .safeAreaInset(edge: .bottom) {
                PlannerTabBar(
                    selection: appCore.selectedTab,
                    onSelect: selectTab(_:)
                )
            }
            .animation(.snappy(duration: 0.26), value: appCore.selectedTab)
    }
}

private extension TabsView {
    @ViewBuilder
    var currentTabView: some View {
        switch appCore.selectedTab {
        case .calendar:
            NavigationStack {
                HomeView(viewModel: homeViewModel)
            }

        case .todo:
            NavigationStack {
                TodoView(viewModel: todoViewModel)
            }

        case .ideas:
            NavigationStack {
                IdeasView(viewModel: ideasViewModel)
            }
        }
    }

    func selectTab(_ tab: AppTab) {
        withAnimation(.snappy(duration: 0.26)) {
            appCore.selectedTab = tab
        }
    }
}

#Preview {
    let appCore = PreviewAppCore.make()
    return TabsView(appCore: appCore)
        .previewAppCore(appCore)
}
