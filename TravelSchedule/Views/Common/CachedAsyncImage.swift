//
//  CachedAsyncImage.swift
//  TravelSchedule
//

import SwiftUI
import UIKit

final class ImageCache {
    static let shared = ImageCache()

    private let cache = NSCache<NSString, UIImage>()

    private init() {}

    func image(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }

    func insert(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}

struct CachedAsyncImage<Content: View, Placeholder: View>: View {

    private let url: URL?
    private let content: (Image) -> Content
    private let placeholder: () -> Placeholder

    @State private var uiImage: UIImage?

    init(
        url: URL?,
        @ViewBuilder content: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder
    ) {
        self.url = url
        self.content = content
        self.placeholder = placeholder
        _uiImage = State(initialValue: url.flatMap { ImageCache.shared.image(for: $0) })
    }

    var body: some View {
        Group {
            if let uiImage {
                content(Image(uiImage: uiImage))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await load()
        }
    }

    private func load() async {
        guard let url else {
            uiImage = nil
            return
        }

        if let cached = ImageCache.shared.image(for: url) {
            uiImage = cached
            return
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return
            }
            guard let downloaded = UIImage(data: data) else { return }
            ImageCache.shared.insert(downloaded, for: url)
            withAnimation(.easeInOut(duration: 0.2)) {
                uiImage = downloaded
            }
        } catch {
        }
    }
}
