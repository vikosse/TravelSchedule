//
//  AuthMiddleware.swift
//  TravelSchedule
//
//  Created by Alekhina Viktoriya on 30/06/2026.
//

import Foundation
import OpenAPIRuntime
import HTTPTypes

struct AuthMiddleware {
    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}

extension AuthMiddleware: ClientMiddleware {
    func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: @Sendable (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = apiKey
        return try await next(request, body, baseURL)
    }
}
