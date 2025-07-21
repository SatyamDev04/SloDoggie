//
//  ChatBubbleView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import SwiftUI
import SwiftUICore

struct ChatBubbleView: View {
    let message: ChatMessage
    let isCurrentUser: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if !isCurrentUser {
                Image(systemName: message.avatar)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }

            VStack(alignment: .leading) {
                Text(message.message)
                    .padding(12)
                    .background(isCurrentUser ? Color.teal : Color.gray.opacity(0.15))
                    .foregroundColor(isCurrentUser ? .white : .black)
                    .cornerRadius(16)
            }

            if isCurrentUser {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, alignment: isCurrentUser ? .trailing : .leading)
        .padding(.horizontal)
    }
}
