//
//  BusiServiceHeaderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct BusiServiceHeaderView: View {
    let provider: BusinessServiceModel?
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showInfo = false
    let isLoading: Bool
    var body: some View {
        
        if let provider = provider {
            VStack(alignment: .leading, spacing: 12) {
                // Top Row
                HStack {
                    // Left image placeholder
                    if let uiImage = UIImage(named: "") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 95, height: 95)
                            .clipShape(Circle())
                    } else {
                        Image("DummyIcon") // your default placeholder asset
                            .resizable()
                            .scaledToFill()
                            .frame(width: 95, height: 95)
                            .clipShape(Circle())
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        // Title + Verified Icon
                        HStack {
                            Text("\(provider.businessName ?? "")")
                                .font(.custom("Outfit-Semibold", size: 14))
                            
                            Image("BlueTickIcon")
                                .foregroundColor(.blue)
                                .font(.system(size: 15))
                            
                            Spacer()
                            
                            // Edit icon
                            Button(action: {
                                coordinator.push(.editBusinessView)
                            }) {
                                Image("PencilIcons")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 17))
                            }
                        }
                        
                        // Rating Row
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 14))
                            
                            Text("\(provider.rating ?? "0")/5")
                                .font(.custom("Outfit-Regular", size: 12))
                            
                            if Int(provider.rating ?? "0") ?? 0 > 0 {
                                Text("(\(provider.rating ?? "0") Ratings)")
                                    .font(.custom("Outfit-Regular", size: 12))
                                    .foregroundColor(.black)
                            }
                            
                        }
                        
                        // Profile Row
                        HStack(spacing: 6) {
                            Text(provider.providerName ?? "")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#9A9A9A"))
                        }
                    }
                }
                //.padding()
                
                // Dropdown
                CustomDisclosure(title: "Additional Info.", isExpanded: $showInfo) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(provider.businessDescription ?? "")
                            .fixedSize(horizontal: false, vertical: true) // Allows multiple lines
                            .multilineTextAlignment(.leading)
                            .padding(.bottom, 8)
                        
                        HStack {
                            Image("Phone2")
                                .frame(width: 15, height: 15)
                            Text("Phone: ")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(provider.phone ?? "")")
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Image("WebsiteIcon")
                                .frame(width: 15, height: 15)
                            Text("Website: ")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(provider.website ?? "")")
                                .foregroundColor(Color(hex: "#258694"))
                                .underline()
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            Image("LocationIcon")
                                .frame(width: 15, height: 15)
                            Text("Address: ")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                            Spacer()
                            Text("\(provider.address ?? "")")
                        }
                        .padding(.horizontal, 10)
                    }
                    .font(.caption)
                }
                //.padding()
                
            }
            .padding()
            //.padding(.trailing, 24)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 2)
            .padding(.horizontal, 16)
        }
        else if isLoading {
            // Skeleton / loader UI
            
            loadingView
        }
    }
}

private var loadingView: some View {
    VStack(alignment: .leading, spacing: 12) {
        HStack {
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 95, height: 95)
            
            VStack(alignment: .leading, spacing: 8) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 18)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 14)
                
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 90, height: 14)
            }
        }
        
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 14)
        
        RoundedRectangle(cornerRadius: 6)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 14)
    }
    .padding()
    .background(Color.white)
    .cornerRadius(12)
    .shadow(radius: 2)
    .padding(.horizontal, 16)
    .redacted(reason: .placeholder)
}
