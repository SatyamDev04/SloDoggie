//
//  EventCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI

struct EventCardView: View {
    let event: Event
    let onTap: () -> Void   // 👈 Add this to handle tap from parent
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: {
                onTap()
            }) {
                VStack(alignment: .leading, spacing: 10) {
                    Image(event.imageName)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 130)
                        .clipped()
                        .cornerRadius(12)

                    HStack {
                        Text(event.title)
                            .font(.custom("Outfit-Medium", size: 14))
                        Spacer()
                        Image("CalenderIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text(event.date)
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(.black)
                    }

                    HStack {
                        Text("Lorem ipsum dolor sit at...")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(.gray)
                        Spacer()
                        Label(event.duration, image: "ClockIcon")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(.black)
                    }

                    HStack {
                        Label(event.location, image: "LocationPin")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle()) // Avoid blue button style

            // Bottom button (optional)
            Button(action: {
                coordinator.push(.chatView)
            }) {
                Text(event.buttonText)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}

