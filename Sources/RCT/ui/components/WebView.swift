//
//  WebView.swift
//  RCT
//
//  Created by Vincent on 03/10/2025.
//

import SwiftUI
import WebKit

#if os(iOS)
struct WebView: UIViewRepresentable {
    
    let html: String
    let baseURL: URL? = nil

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.isOpaque = false
        webView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(html, baseURL: baseURL)
    }
}
#elseif os(macOS)
struct WebView: NSViewRepresentable {
    let html: String
    let baseURL: URL? = nil

    func makeNSView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.setValue(false, forKey: "drawsBackground") // makes background transparent
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        nsView.loadHTMLString(html, baseURL: baseURL)
    }
}
#endif
