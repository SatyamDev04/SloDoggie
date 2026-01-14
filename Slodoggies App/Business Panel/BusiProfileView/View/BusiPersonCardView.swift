//
//  PetCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//

import SwiftUI
 
struct BusiPersonCardView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let pet: BusiUser
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    
                    if pet.businessLogo ?? "" != "" {
                        Image.loadImage(pet.businessLogo ?? "")
                            .scaledToFill()
                            .frame(width: 95, height: 95)
                            .clipShape(Circle())
                        
                    }else {
                        Image("DummyIcon")
                            .resizable()
                            .scaledToFill()
                        frame(width: 95, height: 95)
                            .clipShape(Circle())
                    }
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(pet.providerName ?? "").bold()
                            .padding(.leading, 6)
                        Spacer()
                        //     Button(action: {
                        //      coordinator.push(.editPetProfileView)
                        //      }) {
                        //          Image("PencilIcons")
                        //     }
                    }
                    
                    Text(pet.email ?? "")
                        .font(.custom("Outfit-Medium", size: 12))
                        .foregroundColor(Color(hex: "#258694"))
                        .padding(.leading, 6) .padding(.trailing, 6)
                    
                    Text(pet.bio ?? "")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.black)
                        .padding(.leading, 6)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 2))
        .padding(.horizontal)
    }
}
 
