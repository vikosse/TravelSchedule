//
//  NetworkErrorClassifier.swift
//  TravelSchedule
//

import Foundation
import OpenAPIRuntime

enum NetworkErrorClassifier {

    static func classify(_ error: Error) -> NetworkErrorKind {
        if let urlError = underlyingURLError(in: error), connectivityCodes.contains(urlError.code) {
            return .noInternet
        }
        return .serverError
    }

    private static func underlyingURLError(in error: Error) -> URLError? {
        if let urlError = error as? URLError {
            return urlError
        }
        if let clientError = error as? ClientError {
            return underlyingURLError(in: clientError.underlyingError)
        }
        return nil
    }

    private static let connectivityCodes: Set<URLError.Code> = [
        .notConnectedToInternet,
        .networkConnectionLost,
        .dataNotAllowed,
        .cannotConnectToHost,
        .cannotFindHost,
        .timedOut,
        .internationalRoamingOff
    ]
}
