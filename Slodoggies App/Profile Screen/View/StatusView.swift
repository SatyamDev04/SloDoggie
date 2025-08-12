//
//  StatusView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct StatsView: View {
    let pet: Pet

    var body: some View {
        HStack {
            StatBlock(title: "Posts", value: "\(pet.posts)")
            Divider().frame(height: 30)
            StatBlock(title: "Followers", value: "\(pet.followers / 1000000)M")
            Divider().frame(height: 30)
            StatBlock(title: "Following", value: "\(pet.following)")
        }
        .padding()
     }
   }

struct StatBlock: View {
    let title: String
    let value: String

    var body: some View {
        VStack {
            Text(value).bold()
              .foregroundColor(Color(hex: "#258694"))
            Text(title).font(.caption)
                
        }
        .frame(maxWidth: .infinity)
     }
  }
