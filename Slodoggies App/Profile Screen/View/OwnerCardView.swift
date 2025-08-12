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
                .frame(width: 50, height: 50)
                .clipShape(Circle())

            VStack(alignment: .leading) {
                HStack{
                    Text(user.name).bold()
                    Spacer()
                    Button(action: {
                        coordinator.push(.editProfileView)
                    }) {
                        Image("PencilIcon")
                    }
                }
                Text(user.tag)
                    .font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
                    .padding(4).background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.10)).cornerRadius(6)
                Text(user.bio).font(.caption)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 1))
        .padding(.horizontal)
     }
  }
