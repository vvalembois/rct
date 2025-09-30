//
//  WebView.swift
//  RCT
//
//  Created by Vincent on 03/10/2025.
//

import SwiftUI
import WebKit

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
