//
//  StoriesViewerViewModel.swift
//  TravelSchedule
//

import Foundation
import Combine

enum StoryNavigationRequest: Equatable {
    case advance
    case rewind
    case close
}

@MainActor
final class StoriesViewerViewModel: ObservableObject {

    // MARK: - Published properties

    @Published private(set) var currentStoryIndex: Int
    @Published var navigationRequest: StoryNavigationRequest?

    // MARK: - Dependencies

    let stories: [Story]
    private let viewedStore: StoriesViewedStoreProtocol

    // MARK: - Private properties

    private var pageViewModelsByStoryID: [Int: StoryPageViewModel] = [:]

    // MARK: - Initializer

    init(stories: [Story], initialStoryIndex: Int, viewedStore: StoriesViewedStoreProtocol) {
        self.stories = stories
        self.currentStoryIndex = initialStoryIndex
        self.viewedStore = viewedStore
    }

    // MARK: - Public methods

    func pageViewModel(for story: Story) -> StoryPageViewModel {
        if let existing = pageViewModelsByStoryID[story.id] {
            return existing
        }

        let viewModel = StoryPageViewModel(
            story: story,
            initialPageIndex: 0,
            viewedStore: viewedStore,
            onRequestNextStory: { [weak self] in self?.requestNextStory() },
            onRequestPreviousStory: { [weak self] in self?.requestPreviousStory() }
        )
        pageViewModelsByStoryID[story.id] = viewModel
        return viewModel
    }

    func didCommitStoryChange(to index: Int) {
        currentStoryIndex = index
    }

    // MARK: - Private methods

    private func requestNextStory() {
        guard currentStoryIndex + 1 < stories.count else {
            navigationRequest = .close
            return
        }
        navigationRequest = .advance
    }

    private func requestPreviousStory() {
        guard currentStoryIndex > 0 else { return }
        pageViewModel(for: stories[currentStoryIndex - 1]).rewindToLastPage()
        navigationRequest = .rewind
    }
}
