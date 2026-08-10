//
//  SearchFilter.swift
//  TravelSchedule
//

import Foundation

enum SearchFilter {

    static func apply<T>(_ items: [T], query: String, keyPath: KeyPath<T, String>) -> [T] {
        guard !query.isEmpty else { return items }
        return items.filter { $0[keyPath: keyPath].localizedCaseInsensitiveContains(query) }
    }
}
