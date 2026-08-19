//
//  StoryPagesContentView.swift
//  TravelSchedule
//

import SwiftUI

struct StoryPagesContentView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: StoryPageViewModel

    let isActive: Bool
    let topSafeAreaInset: CGFloat
    let onClose: () -> Void

    // MARK: - Body

    var body: some View {
        ZStack {
            StoryPageView(page: viewModel.currentPage)

            tapZones

            VStack {
                topBar
                Spacer(minLength: 0)
            }
        }
        .onAppear {
            viewModel.setActive(isActive)
        }
        .onChange(of: isActive) { _, newValue in
            viewModel.setActive(newValue)
        }
    }

    // MARK: - Private views

    private var tapZones: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Color.clear
                    .contentShape(Rectangle())
                    .frame(width: proxy.size.width * 0.3)
                    .onTapGesture { viewModel.rewindPage() }

                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { viewModel.advancePage() }
            }
        }
    }

    private var topBar: some View {
        VStack(alignment: .trailing, spacing: 16) {
            progressBarRow
            closeButton
        }
        .padding(.horizontal, 16)
        .padding(.top, topSafeAreaInset + 8)
    }

    private var progressBarRow: some View {
        HStack(spacing: 4) {
            ForEach(0..<viewModel.pageCount, id: \.self) { segmentIndex in
                segmentBar(segmentIndex: segmentIndex)
            }
        }
    }

    private func segmentBar(segmentIndex: Int) -> some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white)

                if segmentIndex < viewModel.pageIndex {
                    Capsule()
                        .fill(Color.ypBlue)
                } else if segmentIndex == viewModel.pageIndex {
                    Capsule()
                        .fill(Color.ypBlue)
                        .frame(width: proxy.size.width * (viewModel.isActive ? viewModel.progressValue : 0))
                        .animation(
                            viewModel.isProgressAnimated ? .linear(duration: StoryPageViewModel.pageDuration) : nil,
                            value: viewModel.progressValue
                        )
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 6)
    }

    private var closeButton: some View {
        Button {
            onClose()
        } label: {
            Image(.close)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
        }
    }
}
