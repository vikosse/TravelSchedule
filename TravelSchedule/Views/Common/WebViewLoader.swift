//
//  WebViewLoader.swift
//  TravelSchedule
//

import WebKit

@MainActor
final class WebViewLoader: NSObject, WKNavigationDelegate {

    let webView = WKWebView()

    private var continuation: CheckedContinuation<Void, Error>?

    override init() {
        super.init()
        webView.navigationDelegate = self
    }

    func load(url: URL) async throws {
        guard webView.url != url else { return }

        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            webView.load(URLRequest(url: url))
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        continuation?.resume()
        continuation = nil
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
