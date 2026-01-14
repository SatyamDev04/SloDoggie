//
//  TextSizeReader.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 09/01/26.
//

import SwiftUI

struct TextSizeReader: View {
    let text: String
    let font: UIFont
    let lineLimit: Int
    let width: CGFloat
    let onResult: (Bool) -> Void

    var body: some View {
        Text(text)
            .font(Font(font))
            .lineLimit(lineLimit)
            .background(
                GeometryReader { geo in
                    Color.clear.onAppear {
                        let fullHeight = text.height(
                            width: width,
                            font: font,
                            lineLimit: nil
                        )
                        let limitedHeight = text.height(
                            width: width,
                            font: font,
                            lineLimit: lineLimit
                        )
                        onResult(fullHeight > limitedHeight)
                    }
                }
            )
            .hidden()
    }
}
