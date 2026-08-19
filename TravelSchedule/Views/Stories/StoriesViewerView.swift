//
//  StoriesViewerView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesViewerView: View {

    // MARK: - Properties

    @StateObject private var viewModel: StoriesViewerViewModel
    @StateObject private var cubeController = CubeTransitionController()

    let onClose: () -> Void

    private let configuration = CubeTransitionConfiguration(
        perspective: 0.35,
        maxAngle: 90,
        swipeThreshold: 0.3,
        velocityThreshold: 550,
        springResponse: 0.35,
        springDamping: 0.9
    )

    // MARK: - Initializer

    init(
        stories: [Story],
        initialStoryIndex: Int,
        viewedStore: StoriesViewedStoreProtocol,
        onClose: @escaping () -> Void
    ) {
        _viewModel = StateObject(
            wrappedValue: StoriesViewerViewModel(
                stories: stories,
                initialStoryIndex: initialStoryIndex,
                viewedStore: viewedStore
            )
        )
        self.onClose = onClose
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            CubeStoryTransition(
                items: viewModel.stories,
                currentIndex: Binding(
                    get: { viewModel.currentStoryIndex },
                    set: { viewModel.didCommitStoryChange(to: $0) }
                ),
                controller: cubeController,
                configuration: configuration,
                onVerticalDismiss: onClose
            ) { story, isActive in
                StoryPagesContentView(
                    viewModel: viewModel.pageViewModel(for: story),
                    isActive: isActive,
                    topSafeAreaInset: proxy.safeAreaInsets.top,
                    onClose: onClose
                )
            }
            .background(Color.black.ignoresSafeArea())
            .ignoresSafeArea()
        }
        .onChange(of: viewModel.navigationRequest) { _, newValue in
            handle(newValue)
        }
    }

    // MARK: - Private methods

    private func handle(_ request: StoryNavigationRequest?) {
        guard let request else { return }
        viewModel.navigationRequest = nil

        switch request {
        case .advance:
            cubeController.advanceForward()
        case .rewind:
            cubeController.advanceBackward()
        case .close:
            onClose()
        }
    }
}

#Preview {
    StoriesViewerView(
        stories: Story.allStories,
        initialStoryIndex: 0,
        viewedStore: StoriesViewedStore(),
        onClose: {}
    )
}
