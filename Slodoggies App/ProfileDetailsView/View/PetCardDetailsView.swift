//
//  PetCardDetailsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct PetCardDetailsView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let pet: Pet

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(pet.image)
                    .resizable()
                    .frame(width: 95, height: 95)
                    .clipShape(Circle())

                VStack(alignment: .leading) {
                    HStack {
                        Text(pet.name).bold()
                        
                    }
                    HStack {
                        Text(pet.breed)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color(red: 0/255, green: 99/255, blue: 122/255))
                            .padding(.leading, 6) .padding(.trailing, 6).background(Color(red: 0/255, green: 99/255, blue: 122/255).opacity(0.1)).cornerRadius(14)
                        
                        Text(pet.age)
                            .font(.custom("Outfit-Medium", size: 12))
                            .foregroundColor(Color(red: 225/255, green: 119/255, blue: 28/255))
                            .padding(.leading, 6) .padding(.trailing, 6) .background(Color(red: 225/255, green: 119/255, blue: 28/255).opacity(0.1)).cornerRadius(14)
                    }
                    Text(pet.bio)
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


