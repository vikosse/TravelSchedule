//
//  StoryPreviewCell.swift
//  TravelSchedule
//

import SwiftUI

struct StoryPreviewCell: View {

    // MARK: - Properties

    let story: Story
    let isViewed: Bool

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .bottom) {
            Image(story.previewImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 92, height: 140)
                .clipped()

            Text(story.pages[0].title)
                .font(.system(size: 10, weight: .regular))
                .foregroundStyle(Color.white)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 8)
                .padding(.bottom, 8)
                .padding(.top, 20)
                .background(
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.65)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            if isViewed {
                Color.white.opacity(0.5)
            }
        }
        .frame(width: 92, height: 140)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(isViewed ? Color.clear : Color.ypBlue, lineWidth: 4)
        )
    }
}

#Preview {
    HStack {
        StoryPreviewCell(story: Story.allStories[0], isViewed: false)
        StoryPreviewCell(story: Story.allStories[1], isViewed: true)
    }
    .padding()
    .background(Color.ypWhite)
}
