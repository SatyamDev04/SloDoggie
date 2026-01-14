//
//  EventCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct EventCardView: View {
    let event: SavedEvent
    let onTap: () -> Void
    @EnvironmentObject private var coordinator: Coordinator

    var mediaImages: [String] {
        event.images?
            .compactMap { $0.mediaPath }
            .filter { !$0.isEmpty } ?? []
    }
    
    private var buttonTitle: String {
        switch event.eventType {
        case "my_event":
            return "Chat"
        case "saved_event":
            return "Join Event"
        default:
            return "Event"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 10) {

                    // Image Slider
                    if !mediaImages.isEmpty {
                        TabView {
                            ForEach(mediaImages, id: \.self) { imageUrl in
                                WebImage(url: URL(string: imageUrl))
                                    .resizable()
                                    .indicator(.activity)
                                    .scaledToFill()
                                    .frame(height: 132)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                        }
                        .frame(height: 132)
                        .tabViewStyle(PageTabViewStyle())
                    } else {
                        // Placeholder
                        Image("placeholderPet")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 132)
                            .clipped()
                            .cornerRadius(12)
                    }

                    // Title & Start Date
                    HStack (spacing: 12){
                        Text(event.eventTitle ?? "")
                            .font(.custom("Outfit-Medium", size: 14))
                        Spacer()
                        Image("CalenderIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(event.eventStartDate ?? "") \(event.eventStartTime ?? "")")
                            .font(.custom("Outfit-Regular", size: 13))
                    }

                    // Description & End Date
                    HStack(spacing: 12) {
                        Text(event.eventDescription ?? "")
                            .font(.custom("Outfit-Regular", size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        Spacer()
                        Image("CalenderIcon")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(event.eventEndDate ?? "") \(event.eventEndTime ?? "")")
                            .font(.custom("Outfit-Regular", size: 13))
                    }

                    // Location
                    Label(event.address ?? "N/A", image: "LocationPin")
                        .font(.custom("Outfit-Medium", size: 14))
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Bottom Button
            Button {
                coordinator.push(.groupChatView)
            } label: {
                Text(buttonTitle)
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
//Button {
//if event.eventType == "my_event" {
//    coordinator.push(.groupChatView)
//} else {
//    coordinator.push(.eventDetail(event.id ?? 0))
//}
//}
