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

    // MARK: - Private Properties

    private let apiKey = Constants.apiKey

    // MARK: - View

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

    // MARK: - Private Methods

    private func makeClient() throws -> Client {
        Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: apiKey)]
        )
    }

    private func testAllServices() {
        Task {
            do {
                let client = try makeClient()

                // 1. getNearestStations
                let nearestStationsService = NearestStationsService(
                    client: client
                )
                let stations = try await nearestStationsService.getNearestStations(
                    lat: 59.864177,
                    lng: 30.319163,
                    distance: 50
                )
                print("Nearest stations: \(stations)")

                // 2. getScheduleBetweenStations
                let scheduleService = ScheduleBetweenStationsService(
                    client: client
                )
                let segments = try await scheduleService.getScheduleBetweenStations(
                    from: "c146",
                    to: "c2"
                )
                print("Schedule between stations: \(segments)")

                // 3. getStationSchedule
                let stationScheduleService = StationScheduleService(
                    client: client
                )
                let stationSchedule = try await stationScheduleService.getStationSchedule(
                    station: "s9600213"
                )
                print("Station schedule: \(stationSchedule)")

                // 4. getRouteStations
                let routeStationsService = RouteStationsService(client: client)
                let routeStations = try await routeStationsService.getRouteStations(
                    uid: "SU-1484_260630_c26_12"
                )
                print("Route stations: \(routeStations)")

                // 5. getNearestCity
                let nearestCityService = NearestCityService(client: client)
                let city = try await nearestCityService.getNearestCity(
                    lat: 59.864177,
                    lng: 30.319163
                )
                print("Nearest city: \(city)")

                // 6. getCarrierInfo
                let carrierInfoService = CarrierInfoService(client: client)
                let carrier = try await carrierInfoService.getCarrierInfo(
                    code: "26"
                )
                print("Carrier info: \(carrier)")

                // 7. getAllStations
                let allStationsService = AllStationsService(client: client)
                let allStations = try await allStationsService.getAllStations()
                print("All stations: \(allStations)")

                // 8. getCopyright
                let copyrightService = CopyrightService(client: client)
                let copyright = try await copyrightService.getCopyright()
                print("Copyright: \(copyright)")

            } catch {
                print("Error: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
