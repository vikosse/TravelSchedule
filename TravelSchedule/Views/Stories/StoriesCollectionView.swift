//
//  StoriesCollectionView.swift
//  TravelSchedule
//

import SwiftUI

struct StoriesCollectionView: View {

    // MARK: - Properties

    @ObservedObject var viewModel: StoriesViewModel

    // MARK: - Body

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(viewModel.stories) { story in
                    StoryPreviewCell(story: story, isViewed: viewModel.isViewed(story))
                        .onTapGesture {
                            viewModel.openViewer(startingAt: story)
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
}

#Preview {
    StoriesCollectionView(viewModel: StoriesViewModel())
}
