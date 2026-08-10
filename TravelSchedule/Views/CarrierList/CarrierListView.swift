//
//  CarrierListView.swift
//  TravelSchedule
//

import SwiftUI

struct CarrierListView: View {

    @StateObject private var viewModel: CarrierListViewModel

    init(route: TravelRoute) {
        _viewModel = StateObject(wrappedValue: CarrierListViewModel(route: route))
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.routeTitle)
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(Color.ypBlack)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 16)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.ypWhite.ignoresSafeArea())
        .safeAreaInset(edge: .bottom) {
            if viewModel.hasSegments {
                refineTimeButton
            }
        }
        .task {
            await viewModel.load()
        }
        .navigationDestination(isPresented: $viewModel.isShowingFilters) {
            FiltersView(
                selectedTimeSlots: viewModel.selectedTimeSlots,
                transfersOption: viewModel.transfersOption
            ) { timeSlots, transfersOption in
                viewModel.applyFilters(timeSlots: timeSlots, transfersOption: transfersOption)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .loading:
            ProgressView()
                .tint(Color.ypBlue)
        case .failure(let networkErrorKind):
            NetworkErrorView(kind: networkErrorKind) {
                Task { await viewModel.load() }
            }
        case .success:
            if viewModel.filteredSegments.isEmpty {
                NotFoundLabel(text: "Вариантов нет")
            } else {
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(viewModel.rowViewModels) { rowViewModel in
                            CarrierRowView(viewModel: rowViewModel)
                        }
                    }
                    .padding(16)
                }
            }
        }
    }

    private var refineTimeButton: some View {
        Button {
            viewModel.showFilters()
        } label: {
            HStack(spacing: 8) {
                Text("Уточнить время")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(Color.white)

                if viewModel.hasActiveFilters {
                    Circle()
                        .fill(Color.ypRed)
                        .frame(width: 8, height: 8)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color.ypBlue)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

#Preview {
    NavigationStack {
        CarrierListView(route: TravelRoute(
            fromCity: City(id: "c213", name: "Москва", stations: []),
            fromStation: Station(id: "s9601788", name: "Ярославский вокзал"),
            toCity: City(id: "c2", name: "Санкт-Петербург", stations: []),
            toStation: Station(id: "s9602497", name: "Балтийский вокзал")
        ))
    }
}
