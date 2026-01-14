//
//  HTMLWebView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/01/26.
//


import SwiftUI
import WebKit

struct HTMLWebView: UIViewRepresentable {

    let htmlContent: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <style>
        body { font-family: -apple-system; }
        img { max-width: 100%; height: auto; }
        </style>
        </head>
        <body>
        \(htmlContent)
        </body>
        </html>
        """
        webView.loadHTMLString(html, baseURL: nil)
    }
}
