//
//  CubeStoryTransition.swift
//  TravelSchedule
//
//  Reusable interactive 3D "cube" transition, generic over any Identifiable
//  item. Knows nothing about story pages, timers, or images — only about
//  paging between `items` at `currentIndex` via drag or programmatic advance.
//

import SwiftUI
import Combine

struct CubeTransitionConfiguration {
    var perspective: CGFloat = 0.35
    var maxAngle: Double = 90
    var swipeThreshold: CGFloat = 0.3
    var velocityThreshold: CGFloat = 550
    var springResponse: Double = 0.35
    var springDamping: Double = 0.9

    static let `default` = CubeTransitionConfiguration()
}

/// Drives the transition's live value and lets external callers (tap zones,
/// auto-advance timers) trigger the same animated cube commit that a manual
/// swipe would produce.
@MainActor
final class CubeTransitionController: ObservableObject {

    enum PendingAdvance: Equatable {
        case forward
        case backward
    }

    // MARK: - Published properties

    @Published var dragTranslation: CGFloat = 0
    @Published var pendingAdvance: PendingAdvance?

    // MARK: - Public methods

    func advanceForward() {
        pendingAdvance = .forward
    }

    func advanceBackward() {
        pendingAdvance = .backward
    }
}

struct CubeStoryTransition<Item: Identifiable, Content: View>: View {

    // MARK: - Properties

    @Binding var currentIndex: Int
    @ObservedObject var controller: CubeTransitionController
    @State private var dragVelocity: CGFloat = 0
    @State private var lastDragSample: (time: Date, translation: CGFloat)?

    let items: [Item]
    let configuration: CubeTransitionConfiguration
    let onVerticalDismiss: (() -> Void)?
    let content: (Item, Bool) -> Content

    // MARK: - Initializer

    init(
        items: [Item],
        currentIndex: Binding<Int>,
        controller: CubeTransitionController,
        configuration: CubeTransitionConfiguration = .default,
        onVerticalDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Item, Bool) -> Content
    ) {
        self.items = items
        self._currentIndex = currentIndex
        self.controller = controller
        self.configuration = configuration
        self.onVerticalDismiss = onVerticalDismiss
        self.content = content
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            let width = max(proxy.size.width, 1)
            let progress = controller.dragTranslation / width

            // Both neighbor faces stay in the tree unconditionally (only array
            // bounds gate them, which never changes mid-transaction). If they were
            // inserted only once `progress` crossed 0, a single withAnimation jump
            // (tap, auto-advance) would see them appear in the "after" state with
            // no "before" state to interpolate from — SwiftUI just pops them in
            // instead of rotating them in. Keeping them permanent, and clamping
            // each one's own progress to the half where it's actually relevant,
            // lets Core Animation interpolate every face continuously regardless
            // of whether the transaction came from a live drag or a single commit.
            let forwardProgress = min(progress, 0)
            let backwardProgress = max(progress, 0)

            ZStack {
                if currentIndex - 1 >= 0 {
                    face(items[currentIndex - 1], isActive: false)
                        .rotation3DEffect(
                            .degrees(configuration.maxAngle * (backwardProgress - 1)),
                            axis: (x: 0, y: 1, z: 0),
                            anchor: .trailing,
                            anchorZ: 0,
                            perspective: configuration.perspective
                        )
                        .offset(x: -width + controller.dragTranslation)
                }

                if currentIndex + 1 < items.count {
                    face(items[currentIndex + 1], isActive: false)
                        .rotation3DEffect(
                            .degrees(configuration.maxAngle * (1 + forwardProgress)),
                            axis: (x: 0, y: 1, z: 0),
                            anchor: .leading,
                            anchorZ: 0,
                            perspective: configuration.perspective
                        )
                        .offset(x: width + controller.dragTranslation)
                }

                face(items[currentIndex], isActive: true)
                    .rotation3DEffect(
                        .degrees(configuration.maxAngle * progress),
                        axis: (x: 0, y: 1, z: 0),
                        anchor: progress <= 0 ? .trailing : .leading,
                        anchorZ: 0,
                        perspective: configuration.perspective
                    )
                    .offset(x: controller.dragTranslation)
            }
            .contentShape(Rectangle())
            .gesture(dragGesture(width: width))
            .onChange(of: controller.pendingAdvance) { _ in
                guard let pending = controller.pendingAdvance else { return }
                controller.pendingAdvance = nil
                switch pending {
                case .forward:
                    commit(to: currentIndex + 1, targetTranslation: -width)
                case .backward:
                    commit(to: currentIndex - 1, targetTranslation: width)
                }
            }
        }
    }

    // MARK: - Private views

    private func face(_ item: Item, isActive: Bool) -> some View {
        content(item, isActive)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .id(item.id)
    }

    // MARK: - Private methods

    private func dragGesture(width: CGFloat) -> some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height

                guard abs(horizontal) > abs(vertical) else { return }

                if horizontal > 0, currentIndex == 0 {
                    controller.dragTranslation = 0
                    return
                }
                if horizontal < 0, currentIndex == items.count - 1 {
                    controller.dragTranslation = 0
                    return
                }

                if let last = lastDragSample {
                    let dt = Date().timeIntervalSince(last.time)
                    if dt > 0.001 {
                        dragVelocity = (horizontal - last.translation) / dt
                    }
                }
                lastDragSample = (Date(), horizontal)
                controller.dragTranslation = max(-width, min(width, horizontal))
            }
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                lastDragSample = nil

                if abs(vertical) > abs(horizontal), vertical > 120 {
                    onVerticalDismiss?()
                    withAnimation(.easeOut(duration: 0.2)) { controller.dragTranslation = 0 }
                    dragVelocity = 0
                    return
                }

                let distanceCommits = abs(controller.dragTranslation) > width * configuration.swipeThreshold
                let velocityCommits = abs(dragVelocity) > configuration.velocityThreshold

                if (distanceCommits || velocityCommits), controller.dragTranslation < 0, currentIndex + 1 < items.count {
                    commit(to: currentIndex + 1, targetTranslation: -width)
                } else if (distanceCommits || velocityCommits), controller.dragTranslation > 0, currentIndex - 1 >= 0 {
                    commit(to: currentIndex - 1, targetTranslation: width)
                } else {
                    withAnimation(.spring(response: configuration.springResponse, dampingFraction: configuration.springDamping)) {
                        controller.dragTranslation = 0
                    }
                }
                dragVelocity = 0
            }
    }

    private func commit(to newIndex: Int, targetTranslation: CGFloat) {
        // A commit started mid-drag already has real finger momentum behind it —
        // a spring reads as a natural continuation of that motion. A commit
        // triggered from rest (tap zone, auto-advance timer) has no momentum to
        // continue, so a spring's slow ease-in would read as a different,
        // slower-feeling animation than the swipe. `easeOut` starts at full speed
        // instead, matching the "already moving" feel of a finished swipe.
        let isFreshCommit = controller.dragTranslation == 0
        let animation: Animation = isFreshCommit
            ? .easeOut(duration: configuration.springResponse)
            : .spring(response: configuration.springResponse, dampingFraction: configuration.springDamping)

        withAnimation(animation) {
            controller.dragTranslation = targetTranslation
        }
        // `withAnimation(_:completion:)` needs iOS 17; the deployment target here is
        // 16.6, so completion is approximated by `springResponse` instead of the
        // real animation's settle time. Good enough visually, but not exact.
        DispatchQueue.main.asyncAfter(deadline: .now() + configuration.springResponse) {
            currentIndex = newIndex
            controller.dragTranslation = 0
        }
    }
}
