//
//  StoriesViewedStore.swift
//  TravelSchedule
//

import Foundation
import Combine

protocol StoriesViewedStoreProtocol {
    func isViewed(_ story: Story) -> Bool
    func markAsViewed(_ story: Story)
}

@MainActor
final class StoriesViewedStore: ObservableObject, StoriesViewedStoreProtocol {

    // MARK: - Published properties

    @Published private(set) var viewedStoryIDs: Set<Int>

    // MARK: - Private properties

    private let defaults: UserDefaults
    private let defaultsKey = "viewedStoryIDs"

    // MARK: - Initializer

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let storedIDs = defaults.array(forKey: defaultsKey) as? [Int] ?? []
        self.viewedStoryIDs = Set(storedIDs)
    }

    // MARK: - Public methods

    func isViewed(_ story: Story) -> Bool {
        viewedStoryIDs.contains(story.id)
    }

    func markAsViewed(_ story: Story) {
        guard !viewedStoryIDs.contains(story.id) else { return }
        viewedStoryIDs.insert(story.id)
        defaults.set(Array(viewedStoryIDs), forKey: defaultsKey)
    }
}
