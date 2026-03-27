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
        TabView(selection: selectionBinding) {
            Tab(
                AppTab.calendar.title,
                systemImage: AppTab.calendar.systemImage,
                value: AppTab.calendar
            ) {
                NavigationStack {
                    HomeView(viewModel: homeViewModel)
                }
            }

            Tab(
                AppTab.todo.title,
                systemImage: AppTab.todo.systemImage,
                value: AppTab.todo
            ) {
                NavigationStack {
                    TodoView(viewModel: todoViewModel)
                }
            }

            Tab(
                AppTab.ideas.title,
                systemImage: AppTab.ideas.systemImage,
                value: AppTab.ideas
            ) {
                NavigationStack {
                    IdeasView(viewModel: ideasViewModel)
                }
            }
        }
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

private extension TabsView {
    var selectionBinding: Binding<AppTab> {
        Binding(
            get: { appCore.selectedTab },
            set: { appCore.selectedTab = $0 }
        )
    }
}

#Preview {
    let appCore = PreviewAppCore.make()
    return TabsView(appCore: appCore)
        .previewAppCore(appCore)
}
