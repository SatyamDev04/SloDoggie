//
//  FeedView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var viewModel = HomeViewModel()
    
    let feedItems: [FeedItemType] = [
        .post(PostModel(username: "Lydia Vaccaro", petName: "Wixx", time: "5 Min.", text: "Meet Wixx...", image: "dog_post_1", likes: 120, comments: 20, shares: 10, tags: [])),
        .ad(AdModel(image: "dog_ad", title: "Summer Special: 20% Off Grooming!", subtitle: "Limited Time Offer", likes: 200, comments: 100, shares: 10)),
        .event(EventModel(title: "Event Title", time: "May 25, 4:00 PM", duration: "30 Mins.", location: "San Luis Obispo County", image: "event_dog", likes: 200, shares: 10)),
        .video(VideoModel(title: "Say hello to Jimmi!", description: "Three years of cuddles...", tags: ["#LifeWithPets", "#SloDoggiesLove"], thumbnail: "video_dog", likes: 200, comments: 100, shares: 15))
    ]
    
    
    var body: some View {
        ZStack{
            VStack{
                HStack {
                    Text("SloDoggies")
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Image("NotificationIcon")
                    }
                    
                    Button(action: {
                        
                    }) {
                        Image("ChatIcon")
                        
                    }
                    .frame(width: 40, height: 40)
                }
                .padding(.horizontal,25)
//                .padding(.bottom,2)
                
                
                        Divider()
                            .frame(height: 2)
                            .background(Color(hex: "#258694"))
                ScrollView {
                    Spacer().frame(height: 10)
                    VStack(spacing: 16) {
                        ForEach(Array(feedItems.enumerated()), id: \.offset) { index, item in
                            switch item {
                            case .post(_):
                                PetPostCardView()
                            case .ad(let ad):
                                AdCard(ad: ad)
                            case .event(let event):
                                EventCard(event: event)
                            case .video(let video):
                                VideoCard(video: video)
                            }
                        }
                    }
                    .refreshable {
                        
                    }
                    .padding(.bottom, 40) // for safe area / tab bar
                    
                }
                .background(Color(hex: "#E5EFF2"))
            }
           
        }
    }
}
#Preview {
    HomeView()
}
