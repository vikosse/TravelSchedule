//
//  MainScreenView.swift
//  TravelSchedule
//

import SwiftUI

struct MainScreenView: View {

    @ObservedObject var viewModel: MainScreenViewModel

    var body: some View {
        VStack(spacing: 16) {
            routeCard

            if viewModel.isSearchAvailable {
                findButton
            }

            Spacer(minLength: 0)
        }
        .padding(.top, 252)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.ypWhite)
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.loadStationsIfNeeded()
        }
        .fullScreenCover(isPresented: $viewModel.isPickerPresented) {
            NavigationStack {
                CitySelectionView(store: viewModel.stationsStore) { city, station in
                    viewModel.apply(city: city, station: station)
                }
            }
        }
        .navigationDestination(isPresented: $viewModel.isShowingCarrierList) {
            if let fromCity = viewModel.fromCity,
               let fromStation = viewModel.fromStation,
               let toCity = viewModel.toCity,
               let toStation = viewModel.toStation {
                CarrierListView(
                    fromCity: fromCity,
                    fromStation: fromStation,
                    toCity: toCity,
                    toStation: toStation
                )
            }
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
            fieldRow(placeholder: "Откуда", text: viewModel.fromText, field: .from)
            fieldRow(placeholder: "Куда", text: viewModel.toText, field: .to)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func fieldRow(placeholder: String, text: String, field: RouteField) -> some View {
        Button {
            viewModel.presentPicker(for: field)
        } label: {
            HStack {
                Text(text.isEmpty ? placeholder : text)
                    .font(.system(size: 17))
                    .foregroundStyle(text.isEmpty ? Color.ypGray : Color.ypBlackUniversal)
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
            viewModel.swapFields()
        } label: {
            Image(.changeButton)
                .resizable()
                .frame(width: 36, height: 36)
        }
        .buttonStyle(.plain)
    }

    private var findButton: some View {
        Button {
            viewModel.find()
        } label: {
            Text("Найти")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.white)
                .frame(width: 150, height: 60)
                .background(Color.ypBlue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    MainScreenView(viewModel: MainScreenViewModel(stationsStore: StationsStore()))
}
