//
//  StatusView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct StatsView: View {
    let pet: Pet
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        HStack {
            StatBlock(title: "Posts", value: "\(pet.posts)")
            
            Divider().frame(width: 1.2, height: 30)
                .background(Color(hex: "#258694"))
            
            StatBlock(title: "Followers", value: "\(pet.followers / 1000000)M") {
                coordinator.push(.followersScreen(initialTab: .followers)) // 👈 followers tab
            }
            
            Divider().frame(width: 1.2, height: 30)
                .background(Color(hex: "#258694"))
            
            StatBlock(title: "Following", value: "\(pet.following)") {
                coordinator.push(.followersScreen(initialTab: .following)) // 👈 following tab
            }
        }
        .padding()
    }
}


struct StatBlock: View {
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

