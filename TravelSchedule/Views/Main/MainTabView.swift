//
//  MainTabView.swift
//  TravelSchedule
//

import SwiftUI

private enum AppTab {
    case main
    case settings
}

enum TabBarMetrics {
    static let contentHeight: CGFloat = 47
}

struct MainTabView: View {

    @State private var selectedTab: AppTab = .main
    @StateObject private var mainScreenViewModel = MainScreenViewModel(stationsStore: StationsStore())
    @State private var mainPath = NavigationPath()
    @State private var isTabBarVisible = true

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Group {
                    if let networkErrorKind = mainScreenViewModel.networkErrorKind {
                        NetworkErrorView(kind: networkErrorKind) {
                            Task { await mainScreenViewModel.retryLoadingStations() }
                        }
                    } else {
                        NavigationStack(path: $mainPath) {
                            MainScreenView(
                                viewModel: mainScreenViewModel,
                                path: $mainPath,
                                isTabBarVisible: $isTabBarVisible
                            )
                        }
                    }
                }
                .hiddenWhen(selectedTab != .main)

                NavigationStack {
                    SettingsView()
                }
                .hiddenWhen(selectedTab != .settings)
            }

            tabBar
                .hiddenWhen(!isTabBarVisible)
        }
    }

    private var tabBar: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.ypLightGrey)

            HStack(spacing: 0) {
                tabButton(tab: .main, icon: .schedule)
                    .frame(maxWidth: .infinity)
                tabButton(tab: .settings, icon: .settings)
                    .frame(maxWidth: .infinity)
            }
            .padding(.vertical, 8)
        }
        .background(Color.ypWhite.ignoresSafeArea(edges: .bottom))
    }

    private func tabButton(tab: AppTab, icon: ImageResource) -> some View {
        Button {
            selectedTab = tab
        } label: {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(selectedTab == tab ? Color.ypBlack : Color.ypGray)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}
