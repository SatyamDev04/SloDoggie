//
//  PostActions.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct PostActions: View {
    let likes: Int
    let comments: Int
    let shares: Int
    var body: some View {
        HStack(spacing: 30) {
            Label("\(likes)", systemImage: "pawprint")
            Label("\(comments)", systemImage: "bubble.left")
            Label("\(shares)", systemImage: "arrowshape.turn.up.right")
            Spacer()
            Image(systemName: "bookmark")
        }
        .font(.caption)
        .padding(.horizontal)
        .foregroundColor(.gray)
    }
}
