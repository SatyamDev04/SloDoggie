//
//  NotificationPermissionView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    @EnvironmentObject private var coordinator: Coordinator
    var body: some View {
            VStack(spacing: 32) {
                Spacer().frame(height: 80)

                Image("AllowNotification")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 145, height: 145)
                    .foregroundColor(.white)
                // Title and subtitle
                VStack(spacing: 8) {
                    Text("Turn on notifications")
                        
                        .font(.custom("Outfit-SemiBold", size: 26))
//                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Please enable notifications to receive\nupdates and reminders")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }

                // Turn On button
                Button(action: {
                    coordinator.push(.locationPermission)
//                    requestNotificationPermission()
                }) {
                    Text("Turn On")
                        .font(.custom("Outfit-SemiBold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // Not Now
                Button(action: {
                    // Handle skip or dismiss
                }) {
                    Text("NOT NOW")
                        .font(.custom("Outfit-SemiBold", size: 16))
                        .foregroundColor(.black)
                }

                Spacer()

                // Paw image
                HStack {
                    Spacer()
                    Image("PawImg") // Add this image in Assets.xcassets
                        .padding(.bottom, 12)
                }
                .padding(.horizontal)
            }
        }

        // Request notification permission
        func requestNotificationPermission() {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notifications allowed")
                    // Navigate to next screen
                } else {
                    print("Notifications not allowed")
                }
                coordinator.push(.locationPermission)
            }
        }
}

#Preview {
    NotificationPermissionView()
}
