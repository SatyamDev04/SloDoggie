//
//  BusiNotificationView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 26/08/25.
//

import SwiftUI

struct BusiNotificationView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            // Custom Navigation Bar
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image("Back")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text("Notifications")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                     Spacer()
            }
                .padding(.bottom)
                .padding(.horizontal, 20)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            // Today Section
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Today")
                        .font(.custom("Outfit-Medium", size: 16))
                        .padding(.horizontal)
                        .padding(.top, 18)
                    
                    Divider()
                        .frame(height: 2)
                        .background(Color(hex: "#646464"))
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                    
                    ForEach(viewModel.notifications) { notification in
                        NotificationRow(notification: notification)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    BusiNotificationView()
}
