//
//  MainTabView.swift
//  TravelSchedule
//

import SwiftUI

private enum AppTab {
    case main
    case settings
}

struct MainTabView: View {

    @State private var selectedTab: AppTab = .main
    @StateObject private var mainScreenViewModel = MainScreenViewModel(stationsStore: StationsStore())

    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                NavigationStack {
                    MainScreenView(viewModel: mainScreenViewModel)
                }
                .opacity(selectedTab == .main ? 1 : 0)
                .allowsHitTesting(selectedTab == .main)

                NavigationStack {
                    PlaceholderScreenView(title: "Настройки")
                }
                .opacity(selectedTab == .settings ? 1 : 0)
                .allowsHitTesting(selectedTab == .settings)
            }

            if !mainScreenViewModel.isShowingCarrierList {
                tabBar
            }
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
                .foregroundStyle(selectedTab == tab ? Color.ypBlue : Color.ypGray)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainTabView()
}
