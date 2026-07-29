//
//  CitySelectionView.swift
//  TravelSchedule
//

import SwiftUI

struct CitySelectionView: View {

    let onSelect: (City, Station) -> Void

    @StateObject private var viewModel: CityPickerViewModel
    @Environment(\.dismiss) private var dismiss

    init(store: StationsStore, onSelect: @escaping (City, Station) -> Void) {
        self.onSelect = onSelect
        _viewModel = StateObject(wrappedValue: CityPickerViewModel(store: store))
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.searchText)
                .padding(.vertical, 8)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.ypWhite.ignoresSafeArea())
        .navigationTitle("Выбор города")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.ypBlack)
                }
            }
        }
        .task {
            await viewModel.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .tint(Color.ypBlue)
        } else if let errorMessage = viewModel.errorMessage {
            VStack(spacing: 12) {
                Text(errorMessage)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ypGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button("Повторить") {
                    Task { await viewModel.reload() }
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.ypBlue)
            }
        } else if viewModel.filteredCities.isEmpty {
            NotFoundLabel(text: "Город не найден")
        } else {
            cityList
        }
    }

    private var cityList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.filteredCities) { city in
                    NavigationLink {
                        StationSelectionView(city: city) { station in
                            onSelect(city, station)
                        }
                    } label: {
                        LocationRow(title: city.name, showsChevron: true)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CitySelectionView(store: StationsStore()) { _, _ in }
    }
}
