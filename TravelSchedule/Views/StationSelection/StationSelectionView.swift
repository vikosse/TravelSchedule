//
//  StationSelectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StationSelectionView: View {

    let onSelect: (Station) -> Void

    @StateObject private var viewModel: StationPickerViewModel

    init(city: City, onSelect: @escaping (Station) -> Void) {
        self.onSelect = onSelect
        _viewModel = StateObject(wrappedValue: StationPickerViewModel(city: city))
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $viewModel.searchText)
                .padding(.vertical, 8)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.ypWhite.ignoresSafeArea())
        .navigationTitle("Выбор станции")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.filteredStations.isEmpty {
            NotFoundLabel(text: "Станция не найдена")
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.filteredStations) { station in
                        Button {
                            onSelect(station)
                        } label: {
                            LocationRow(title: station.name)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

#Preview {
    let previewCity = City(
        id: "c213",
        name: "Москва",
        stations: [
            Station(id: "s9600721", name: "Курский вокзал"),
            Station(id: "s9601788", name: "Ярославский вокзал")
        ]
    )

    NavigationStack {
        StationSelectionView(city: previewCity) { _ in }
    }
}
