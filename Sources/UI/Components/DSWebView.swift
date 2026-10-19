//
//  DSWebView.swift
//  RCTUI
//
//  Created by Vincent Valembois on 03/10/2025.
//

import SwiftUI
import WebKit

/// Renders an HTML string with WebKit (transparent background).
#if os(iOS)
public struct DSWebView: UIViewRepresentable {

    private let html: String
    private let baseURL: URL?

    public init(html: String, baseURL: URL? = nil) {
        self.html = html
        self.baseURL = baseURL
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: Context) {
        guard context.coordinator.loadedHTML != html else { return }
        context.coordinator.loadedHTML = html
        uiView.loadHTMLString(html, baseURL: baseURL)
    }

    public final class Coordinator {
        var loadedHTML: String?
    }
}
#elseif os(macOS)
public struct DSWebView: NSViewRepresentable {

    private let html: String
    private let baseURL: URL?

    public init(html: String, baseURL: URL? = nil) {
        self.html = html
        self.baseURL = baseURL
    }

    public func makeCoordinator() -> Coordinator { Coordinator() }

    public func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground")
        return webView
    }

    public func updateNSView(_ nsView: WKWebView, context: Context) {
        guard context.coordinator.loadedHTML != html else { return }
        context.coordinator.loadedHTML = html
        nsView.loadHTMLString(html, baseURL: baseURL)
    }

    public final class Coordinator {
        var loadedHTML: String?
    }
}
#endif
