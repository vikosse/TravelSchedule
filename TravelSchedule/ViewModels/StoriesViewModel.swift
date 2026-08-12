//
//  StoriesViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

@MainActor
final class StoriesViewModel: ObservableObject {

    // MARK: - Published properties

    @Published var isViewerPresented = false
    @Published private(set) var initialStoryIndex = 0

    // MARK: - Dependencies

    let stories: [Story]
    let viewedStore: StoriesViewedStore

    // MARK: - Private properties

    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initializer

    init(stories: [Story] = Story.allStories, viewedStore: StoriesViewedStore? = nil) {
        let viewedStore = viewedStore ?? StoriesViewedStore()
        self.stories = stories
        self.viewedStore = viewedStore

        viewedStore.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }

    // MARK: - Public methods

    func isViewed(_ story: Story) -> Bool {
        viewedStore.isViewed(story)
    }

    func openViewer(startingAt story: Story) {
        guard let index = stories.firstIndex(where: { $0.id == story.id }) else { return }
        initialStoryIndex = index
        isViewerPresented = true
    }
}
