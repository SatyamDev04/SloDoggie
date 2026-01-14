//
//  NotificationPermissionView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI
import UserNotifications

struct LocationPermissionView: View {
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
                    Image("allowLocation") // Or use your "AllowNotification" image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                }
                .onAppear {
                    animate = true
                }

                VStack(spacing: 8) {
                    Text("Turn on Location")
                        .font(.custom("Outfit-SemiBold", size: 26))
//                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("Allow maps to access your location while you use the app?")
                        .font(.custom("Outfit-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top)
                        .padding(.horizontal, 50)
                }

                // Turn On button
                Button(action: {
                    if let settingsURL = URL(string: UIApplication.openSettingsURLString),
                       UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
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
                    coordinator.push(.tabBar)
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

       
}

#Preview {
    LocationPermissionView()
}
