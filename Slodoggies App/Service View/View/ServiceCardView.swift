//
//  ServiceCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProviderCardView: View {
    
    let provider: ServiceItem
    @EnvironmentObject private var coordinator: Coordinator
    
    private var ratingText: String {
        String(format: "%.1f", Double(provider.averageRating ?? "0") ?? 0)
    }
    
    private var firstCategory: String {
        provider.categoryName?
            .compactMap { $0 }
            .first ?? "N/A"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            providerImage
            
            Text(provider.serviceName ?? "Unknown Service")
                .font(.custom("Outfit-Medium", size: 14))
            
            Text(provider.providerName ?? "Unknown Provider")
                .font(.custom("Outfit-Regular", size: 12))
            
            HStack {
                Image("StarIcon")
                Text("\(ratingText)/5")
            }
            
            Text(provider.distance ?? "Unknown")
            
            categoryTag
            
            inquireButton
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var providerImage: some View {
        Group {
            if let url = URL(string: provider.image ?? "") {
                WebImage(url: url)
                    .resizable()
                    .scaledToFill()
            } else {
                Image("DogFootIcon")
                    .resizable()
            }
        }
        .frame(width: 50, height: 50)
        .cornerRadius(6)
    }
    
    private var categoryTag: some View {
        Text(firstCategory)
            .font(.custom("Outfit-Regular", size: 11))
            .padding(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.gray)
            )
    }
    
    private var inquireButton: some View {
        Button {
            coordinator.push(.chatView)
        } label: {
            HStack {
                Image("ChatIcon1")
                    .frame(width: 16, height: 16)
                Text("Inquire now")
                    .font(.custom("Outfit-SemiBold", size: 12))
                    .foregroundColor(Color(hex: "#258694"))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 32)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#258694"))
        )
    }
}

