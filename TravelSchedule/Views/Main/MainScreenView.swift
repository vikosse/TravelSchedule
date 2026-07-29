//
//  MainScreenView.swift
//  TravelSchedule
//

import SwiftUI

private enum RouteField {
    case from
    case to
}

struct MainScreenView: View {

    @State private var stationsStore = StationsStore()

    @State private var fromCity: City?
    @State private var fromStation: Station?
    @State private var toCity: City?
    @State private var toStation: Station?

    @State private var isPickerPresented = false
    @State private var activeField: RouteField = .from

    private var fromText: String {
        routeText(city: fromCity, station: fromStation)
    }

    private var toText: String {
        routeText(city: toCity, station: toStation)
    }

    private var isSearchAvailable: Bool {
        fromStation != nil && toStation != nil
    }

    var body: some View {
        VStack(spacing: 16) {
            routeCard

            if isSearchAvailable {
                findButton
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 252)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.ypWhite)
        .ignoresSafeArea(edges: .top)
        .task {
            await stationsStore.loadIfNeeded()
        }
        .fullScreenCover(isPresented: $isPickerPresented) {
            NavigationStack {
                CitySelectionView { city, station in
                    apply(city: city, station: station)
                    isPickerPresented = false
                }
            }
            .environment(stationsStore)
        }
    }

    private var routeCard: some View {
        HStack(spacing: 16) {
            fieldsContainer
                .frame(maxWidth: .infinity)

            swapButton
        }
        .padding(16)
        .frame(height: 128)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.ypBlue)
        )
        .padding(.horizontal, 16)
    }

    private var fieldsContainer: some View {
        VStack(spacing: 0) {
            fieldRow(placeholder: "Откуда", text: fromText, field: .from)
            fieldRow(placeholder: "Куда", text: toText, field: .to)
        }
        .background(Color.ypWhite)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func fieldRow(placeholder: String, text: String, field: RouteField) -> some View {
        Button {
            activeField = field
            isPickerPresented = true
        } label: {
            HStack {
                Text(text.isEmpty ? placeholder : text)
                    .font(.system(size: 17))
                    .foregroundStyle(text.isEmpty ? Color.ypGray : Color.ypBlack)
                    .lineLimit(1)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 16)
            .frame(height: 48)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private var swapButton: some View {
        Button {
            swapFields()
        } label: {
            Image(.changeButton)
                .resizable()
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
    }

    private var findButton: some View {
        Button {
        } label: {
            Text("Найти")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.ypWhite)
                .frame(width: 150, height: 60)
                .background(Color.ypBlue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private func routeText(city: City?, station: Station?) -> String {
        guard let city else { return "" }
        guard let station else { return city.name }
        return "\(city.name) (\(station.name))"
    }

    private func apply(city: City, station: Station) {
        switch activeField {
        case .from:
            fromCity = city
            fromStation = station
        case .to:
            toCity = city
            toStation = station
        }
    }

    private func swapFields() {
        swap(&fromCity, &toCity)
        swap(&fromStation, &toStation)
    }
}

#Preview {
    MainScreenView()
}
