//
//  StoryPageView.swift
//  TravelSchedule
//

import SwiftUI

struct StoryPageView: View {

    // MARK: - Properties

    let page: StoryPage

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            Image(page.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: proxy.size.width, height: proxy.size.height)
                .clipped()
                .overlay(alignment: .bottom) {
                    textOverlay
                }
        }
        .ignoresSafeArea()
    }

    // MARK: - Private views

    private var textOverlay: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(page.title)
                .font(.system(size: 34, weight: .bold))
                .foregroundStyle(.white)

            Text(page.subtitle)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 40)
        .padding(.top, 100)
        .background(
            LinearGradient(
                colors: [.clear, .black.opacity(0.7)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    StoryPageView(page: Story.allStories[0].pages[0])
}
