//
//  StoryPageViewModel.swift
//  TravelSchedule
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class StoryPageViewModel: ObservableObject {

    private static let pageDuration = 10.0

    // MARK: - Published properties

    @Published private(set) var pageIndex: Int
    @Published private(set) var progressValue: CGFloat = 0
    @Published private(set) var isActive = false

    // MARK: - Dependencies

    let story: Story
    private let viewedStore: StoriesViewedStoreProtocol
    private let onRequestNextStory: () -> Void
    private let onRequestPreviousStory: () -> Void

    // MARK: - Private properties

    private var timerTask: Task<Void, Never>?

    // MARK: - Computed properties

    var pageCount: Int {
        story.pages.count
    }

    var currentPage: StoryPage {
        story.pages[pageIndex]
    }

    // MARK: - Initializer

    init(
        story: Story,
        initialPageIndex: Int,
        viewedStore: StoriesViewedStoreProtocol,
        onRequestNextStory: @escaping () -> Void,
        onRequestPreviousStory: @escaping () -> Void
    ) {
        self.story = story
        self.pageIndex = initialPageIndex
        self.viewedStore = viewedStore
        self.onRequestNextStory = onRequestNextStory
        self.onRequestPreviousStory = onRequestPreviousStory
    }

    deinit {
        timerTask?.cancel()
    }

    // MARK: - Public methods

    func setActive(_ active: Bool) {
        guard isActive != active else { return }
        isActive = active

        if active {
            viewedStore.markAsViewed(story)
            restartTimer()
        } else {
            timerTask?.cancel()
        }
    }

    func advancePage() {
        if pageIndex + 1 < story.pages.count {
            pageIndex += 1
            restartTimer()
        } else {
            onRequestNextStory()
        }
    }

    func rewindPage() {
        if pageIndex > 0 {
            pageIndex -= 1
            restartTimer()
        } else {
            onRequestPreviousStory()
        }
    }

    func rewindToLastPage() {
        pageIndex = story.pages.count - 1
        if isActive {
            restartTimer()
        }
    }

    // MARK: - Private methods

    private func restartTimer() {
        timerTask?.cancel()
        progressValue = 0

        timerTask = Task { [weak self] in
            guard let self else { return }
            withAnimation(.linear(duration: Self.pageDuration)) {
                self.progressValue = 1
            }
            try? await Task.sleep(for: .seconds(Self.pageDuration))
            guard !Task.isCancelled else { return }
            self.advancePage()
        }
    }
}
