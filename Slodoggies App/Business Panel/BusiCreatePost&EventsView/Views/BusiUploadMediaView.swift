//
//  BusiUploadMediaView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI

struct BusiUploadMediaView: View {
    var body: some View {
        VStack {
            Image("material-symbols_upload")
                .font(.title)
            Text("Upload Here")
                .font(.footnote)
                .foregroundColor(Color(hex: "#258694"))
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(Color(hex: "#258694"))
        )
    }
}
