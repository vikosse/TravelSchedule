//
//  CarrierListView.swift
//  TravelSchedule
//

import SwiftUI

struct CarrierListView: View {

    @StateObject private var viewModel: CarrierListViewModel

    init(fromCity: City, fromStation: Station, toCity: City, toStation: Station) {
        _viewModel = StateObject(wrappedValue: CarrierListViewModel(
            fromCity: fromCity,
            fromStation: fromStation,
            toCity: toCity,
            toStation: toStation
        ))
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
            if !viewModel.segments.isEmpty {
                refineTimeButton
            }
        }
        .task {
            await viewModel.load()
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
                    Task { await viewModel.load() }
                }
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.ypBlue)
            }
        } else if viewModel.segments.isEmpty {
            NotFoundLabel(text: "Вариантов нет")
        } else {
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(Array(viewModel.segments.enumerated()), id: \.offset) { _, segment in
                        CarrierRow(viewModel: CarrierRowViewModel(segment: segment, fallbackDate: ScheduleFormatter.today()))
                    }
                }
                .padding(16)
            }
        }
    }

    private var refineTimeButton: some View {
        Button {
        } label: {
            Text("Уточнить время")
                .font(.system(size: 17, weight: .bold))
                .foregroundStyle(Color.ypWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.ypBlue)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .background(Color.ypWhite)
    }
}

#Preview {
    NavigationStack {
        CarrierListView(
            fromCity: City(id: "c213", name: "Москва", stations: []),
            fromStation: Station(id: "s9601788", name: "Ярославский вокзал"),
            toCity: City(id: "c2", name: "Санкт-Петербург", stations: []),
            toStation: Station(id: "s9602497", name: "Балтийский вокзал")
        )
    }
}
