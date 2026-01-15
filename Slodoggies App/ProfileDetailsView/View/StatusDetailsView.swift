//
//  StatusDetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct StatusDetailsView: View {
    var userID: String
    let postCount: String?
    let followersCount: String?
    let followingCount: String?
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        HStack {
            StatBlock(title: "Posts", value: postCount ?? "")
            
            Divider().frame(width: 1.2, height: 30)
                .background(Color(hex: "#258694"))
            
            StatBlock(title: "Followers", value: followersCount ?? "") {
                coordinator.push(.followersScreen(userID, initialTab: .followers)) // 👈 followers tab
            }
            
            Divider().frame(width: 1.2, height: 30)
                .background(Color(hex: "#258694"))
            
            StatBlock(title: "Following", value: followingCount ?? "") {
                coordinator.push(.followersScreen(userID, initialTab: .following)) // 👈 following tab
            }
        }
        .padding()
    }
}



struct StatDetailsBlock: View {
    let title: String
    let value: String
    var action: (() -> Void)? = nil   // optional action

    var body: some View {
        VStack {
            Text(value).bold()
                .foregroundColor(Color(hex: "#258694"))
                .font(.custom("Outfit-Medium", size: 16))
            
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle()) // makes full block tappable
        .onTapGesture {
            action?()  // run action only if provided
        }
      }
    }

