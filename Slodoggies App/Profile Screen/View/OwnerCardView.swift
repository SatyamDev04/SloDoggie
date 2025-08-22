//
//  OwnerCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI

struct OwnerCardView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let user: User

    var body: some View {
        HStack {
            Image(user.image)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                HStack{
                    Text(user.name).bold()
                    Spacer()
                    Button(action: {
                        coordinator.push(.editProfileView)
                    }) {
                        Image("PencilIcons")
                    }
                }
                Text(user.tag)
                    .font(.custom("Outfit-Medium", size: 10))
                    .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
                    .padding(.leading, 6) .padding(.trailing, 6) .background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.1)).cornerRadius(14)
                Text(user.bio).font(.caption)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 1))
        .padding(.horizontal)
     }
  }
