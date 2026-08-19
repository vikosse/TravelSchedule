//
//  Story.swift
//  TravelSchedule
//

import Foundation

struct StoryPage: Identifiable, Hashable, Sendable {
    let id: Int
    let imageName: String
    let title: String
    let subtitle: String
}

struct Story: Identifiable, Hashable, Sendable {
    let id: Int
    let previewImageName: String
    let pages: [StoryPage]
}

extension Story {
    static let allStories: [Story] = (1...9).map { index in
        let firstPageID = (index - 1) * 2 + 1
        let secondPageID = firstPageID + 1
        return Story(
            id: index,
            previewImageName: "Preview/\(index)",
            pages: [
                StoryPage(id: firstPageID, imageName: "Big/\(firstPageID)", title: "Title", subtitle: "Subtitle"),
                StoryPage(id: secondPageID, imageName: "Big/\(secondPageID)", title: "Title", subtitle: "Subtitle")
            ]
        )
    }
}
