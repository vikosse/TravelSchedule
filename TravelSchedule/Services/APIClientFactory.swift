//
//  APIClientFactory.swift
//  TravelSchedule
//

import OpenAPIRuntime
import OpenAPIURLSession

enum APIClientFactory {

    static func makeClient() throws -> Client {
        Client(
            serverURL: try Servers.Server1.url(),
            transport: URLSessionTransport(),
            middlewares: [AuthMiddleware(apiKey: Constants.apiKey)]
        )
    }
}
