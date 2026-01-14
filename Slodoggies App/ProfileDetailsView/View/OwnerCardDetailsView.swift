//
//  OwnerCardDetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct OwnerCardDetailsView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let user: OwnerDetails

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                    .frame(width: 70, height: 70)
                if let image = user.image {
                    Image.loadImage(image, width: 60, height: 60)
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image("NoUserFound")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                }
            }
            VStack(alignment: .leading) {
//                HStack(spacing: 6){
                    Text(user.name ?? "")
                        .font(.custom("Outfit-Medium", size: 12))
//                  }
                Spacer().frame(height: 25)
//                Text(user.userType ?? "")
//                    .frame(height: 25)
//                    .font(.custom("Outfit-Medium", size: 10))
//                    .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
//                    .padding(.leading, 6) .padding(.trailing, 6) .background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.1)).cornerRadius(14)
                Text(user.bio ?? "")
                    .font(.custom("Outfit-Regular", size: 12))
            }
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12)
            .fill(Color.white)
            .shadow(radius: 1))
        .padding(.horizontal)
     }
  }
