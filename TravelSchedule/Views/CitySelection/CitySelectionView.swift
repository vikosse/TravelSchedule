//
//  CitySelectionView.swift
//  TravelSchedule
//

import SwiftUI

struct CitySelectionView: View {

    let onSelect: (City, Station) -> Void

    @Environment(StationsStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    private var filteredCities: [City] {
        guard !searchText.isEmpty else { return store.cities }
        return store.cities.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack(spacing: 0) {
            SearchField(text: $searchText)
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
            await store.loadIfNeeded()
        }
    }

    @ViewBuilder
    private var content: some View {
        if store.isLoading {
            ProgressView()
                .tint(Color.ypBlue)
        } else if let errorMessage = store.errorMessage {
            VStack(spacing: 12) {
                Text(errorMessage)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.ypGray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button("Повторить") {
                    Task { await store.reload() }
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.ypBlue)
            }
        } else if filteredCities.isEmpty {
            NotFoundLabel(text: "Город не найден")
        } else {
            cityList
        }
    }

    private var cityList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredCities) { city in
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
        CitySelectionView { _, _ in }
    }
    .environment(StationsStore())
}
