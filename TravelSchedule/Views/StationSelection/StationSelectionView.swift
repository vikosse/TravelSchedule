//
//  StationSelectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StationSelectionView: View {

    let city: City
    let onSelect: (Station) -> Void

    @State private var searchText = ""

    private var filteredStations: [Station] {
        guard !searchText.isEmpty else { return city.stations }
        return city.stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $searchText)
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
        if filteredStations.isEmpty {
            NotFoundLabel(text: "Станция не найдена")
        } else {
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredStations) { station in
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
