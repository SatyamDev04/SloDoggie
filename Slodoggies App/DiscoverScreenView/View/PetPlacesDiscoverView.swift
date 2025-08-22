//
//  PetPlacesDiscoverView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI

struct PetPlaceCard: View {
    let place: PetPlaceModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(place.imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 120)
                .clipped()
                .cornerRadius(10)
            
            Text(place.name)
                .font(.custom("Outfit-SemiBold", size: 14))
                .foregroundColor(.black)
                .lineLimit(1)
            
            if let location = place.place{
                Text(location)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            
            if let distance = place.distance {
                Text(distance)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.black)
            }
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        .border(Color.gray.opacity(0.2), width: 1)
    }
}
