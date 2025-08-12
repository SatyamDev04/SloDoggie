//
//  EmptyPetCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//
import SwiftUI

struct EmptyPetCardView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
            Text("Pet name")
            Text("Breed    Age")
            Text("Bio")
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.5)))
        .padding(.horizontal)
    }
}
