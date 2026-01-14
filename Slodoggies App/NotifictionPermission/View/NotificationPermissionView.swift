//
//  NotificationPermissionView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import UserNotifications

import SwiftUI
import UserNotifications

struct NotificationPermissionView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var animate = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer().frame(height: 80)

            ZStack {
                // Ripple effect circles
                Circle()
                    .fill(Color(hex: "#A8D3DA").opacity(0.6)) // outer ripple color
                    .frame(width: 200, height: 200)
                    .scaleEffect(animate ? 1.2 : 0.8)
                    .opacity(animate ? 0.3 : 0.6)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animate)

                Circle()
                    .fill(Color(hex: "#2C8A96"))
                    .frame(width: 120, height: 120)

                // Bell Icon
                Image("AllowNotification") // Or use your "AllowNotification" image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
            }
            .onAppear {
                animate = true
            }

            // Title and subtitle
            VStack(spacing: 8) {
                Text("Turn on notifications")
                    .font(.custom("Outfit-SemiBold", size: 26))
                    .foregroundColor(.black)

                Text("Please enable notifications to receive\nupdates and reminders.")
                    .font(.custom("Outfit-Regular", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal)
                    .padding(.top)
            }

            // Turn On button
            Button(action: {
                // Opens the app's notification settings in iOS Settings
                if let appSettings = URL(string: UIApplication.openSettingsURLString),
                   UIApplication.shared.canOpenURL(appSettings) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
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
                coordinator.push(.locationPermission)
            }) {
                Text("NOT NOW")
                    .font(.custom("Outfit-SemiBold", size: 16))
                    .foregroundColor(.black)
            }

            Spacer()

            // Paw image
            HStack {
                Spacer()
                Image("PawImg")
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
