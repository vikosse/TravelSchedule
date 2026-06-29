//
//  ContentView.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 28/06/2026.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            testAllServices()
        }
    }
}

// MARK: - Тестовые вызовы методов

private let apiKey = Constants.apiKey

private func makeClient() throws -> Client {
    Client(
        serverURL: try Servers.Server1.url(),
        transport: URLSessionTransport()
    )
}

private func testAllServices() {
    Task {
        do {
            let client = try makeClient()

            // 1. Список ближайших станций
            let nearestStationsService = NearestStationsService(client: client, apikey: apiKey)
            print("--- getNearestStations ---")
            let stations = try await nearestStationsService.getNearestStations(
                lat: 59.864177,
                lng: 30.319163,
                distance: 50
            )
            print("Stations: \(stations)")

            // 2. Расписание между станциями
            let scheduleService = ScheduleBetweenStationsService(client: client, apikey: apiKey)
            print("--- getScheduleBetweenStations ---")
            let segments = try await scheduleService.getScheduleBetweenStations(
                from: "c213",  // Мск
                to: "c2"       // Спб
            )
            print("Segments: \(segments)")

            // 3. Расписание по станции
            let stationScheduleService = StationScheduleService(client: client, apikey: apiKey)
            print("--- getStationSchedule ---")
            let schedule = try await stationScheduleService.getStationSchedule(
                station: "s9600213"
            )
            print("Schedule: \(schedule)")

            // 4. Список маршрутов
            let routeStationsService = RouteStationsService(client: client, apikey: apiKey)
            print("--- getRouteStations ---")
            let route = try await routeStationsService.getRouteStations(
                uid: "SU-1484_260630_c26_12" // актуальный рейс Мск - Красноярск
            )
            print("Маршрут: \(route)")

            // 5. Ближайший город
            let nearestCityService = NearestCityService(client: client, apikey: apiKey)
            print("--- getNearestCity ---")
            let city = try await nearestCityService.getNearestCity(
                lat: 59.864177,
                lng: 30.319163
            )
            print("Nearest city: \(city)")

            // 6. Информация о перевозчике
            let carrierService = CarrierInfoService(client: client, apikey: apiKey)
            print("--- getCarrierInfo ---")
            let carrier = try await carrierService.getCarrierInfo(code: "26") // числовой код Аэрофлота
            print("Carrier: \(carrier)")

            // 7. Список всех станций
            let allStationsService = AllStationsService(client: client, apikey: apiKey)
            print("--- getAllStations ---")
            let allStations = try await allStationsService.getAllStations()
            print("All stations countries count: \(allStations.countries?.count ?? 0)")

            // 8. Копирайт
            let copyrightService = CopyrightService(client: client, apikey: apiKey)
            print("--- getCopyright ---")
            let copyright = try await copyrightService.getCopyright()
            print("Copyright: \(copyright)")

        } catch {
            print("Error: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
