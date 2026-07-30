//
//  NetworkErrorKind.swift
//  TravelSchedule
//

import DeveloperToolsSupport

enum NetworkErrorKind {
    case noInternet
    case serverError

    var title: String {
        switch self {
        case .noInternet: return "Нет интернета"
        case .serverError: return "Ошибка сервера"
        }
    }

    var imageResource: ImageResource {
        switch self {
        case .noInternet: return .noInternet
        case .serverError: return .serverError
        }
    }
}
