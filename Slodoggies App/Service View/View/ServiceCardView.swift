//
//  ServiceCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct ProviderCardView: View {
    let provider: Provider

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("DogFootIcon")
                .resizable()
                .frame(width: 50, height: 50)

            Text(provider.servieName)
                .font(.custom("Outfit-Medium", size: 14))

            HStack{
                Text(provider.provideName)
                    .font(.custom("Outfit-Medium", size: 12))
                    .foregroundColor(Color(hex: "#212121"))
                
                Image("BlueTickIcon")
                    .resizable()
                    .frame(width: 11, height: 11)
            }
            .padding(.top, -4)
            
            HStack{
                Image("StarIcon")
                    .resizable()
                    .frame(width: 16, height: 16)
                Text("\(String(format: "%.1f", provider.rating))/5")
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.gray)
            }
            Text(provider.serviceType)
                .font(.custom("Outfit-Regular", size: 11))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .frame(width: .infinity, height: 25)
                .foregroundColor(Color(hex: "#8A8894"))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "#CDCDCD"), lineWidth: 1)
                )

            Button(action: {
                
            }) {
                HStack {
                    Image("ChatIcon1")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text("Inquire now")
                        .foregroundColor(Color(hex: "#258694"))
                }
            }
            .font(.custom("Outfit-Medium", size: 14))
            .padding(6)
            .frame(height: 42)
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(hex: "#258694"), lineWidth: 1)
            )
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
 }
