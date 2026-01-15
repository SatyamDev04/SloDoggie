//
//  PetCardDetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct PetCardDetailsView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let pet: PetsDetailData

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                        .frame(width: 105, height: 105)
                    if let image = pet.petImage {
                        Image.loadImage(image, width: 95, height: 95)
                            .scaledToFill()
                            .clipShape(Circle())
                    } else {
                        Image("NoPetImg")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 95, height: 95)
                            .clipShape(Circle())
                    }
                }
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(pet.petName ?? "")
                            .font(.custom("Outfit-Medium", size: 16))
                        
                        Spacer()
                      }
                    
                    HStack {
                        Text(pet.petBreed ?? "")
                            .frame(height: 25)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
                            .padding(.leading, 6) .padding(.trailing, 6).background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.1)).cornerRadius(14)
                        
                        Text("\(pet.petAge ?? "") Years Olds")
                            .frame(height: 25)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color(red: 225/255, green: 119/255, blue: 28/255))
                            .padding(.leading, 6) .padding(.trailing, 6) .background(Color(red: 225/255, green: 119/255, blue: 28/255).opacity(0.1)).cornerRadius(14)
                    }
                    Text(pet.petBio ?? "")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.black)
               }
            }
         }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 2))
        .padding(.horizontal)
     }
  }
