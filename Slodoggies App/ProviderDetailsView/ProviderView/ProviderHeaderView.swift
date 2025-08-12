//
//  ProviderHeaderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ProviderHeaderView: View {
    let provider: ProviderModel
    let followAction: () -> Void

    @State private var showInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Top Row
            HStack {
                Image("DogFootIcon")
                    .resizable()
                    .frame(width: 50, height: 50)

                Spacer()

                Text("Grooming")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundColor(Color.gray)
                    .frame(width: 71 , height: 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1)
                    )
            }

            // Title & Rating & Buttons
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Pawfect Pet Care")
                        .font(.headline)
                    
                    HStack(spacing: 4) {
                        Image("StarIcon")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("4.8/5")
                            .font(.caption)
                    }
                }
                
                Spacer()
                VStack{
                    Button(action: {}) {
                        HStack {
                            Image("ChatIcon1")
                            Text("Inquire now")
                        }
                        .font(.footnote)
                        .foregroundColor(Color.init(hex: "#258694"))
                        .padding(.horizontal, 12)
                        .frame(width: 121, height: 31)
                        .padding(.vertical, 6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#258694"), lineWidth: 1)
                        )
                    }
                }
            }

            // Provider Info Row
            HStack(spacing: 6) {
                Image("People1") // Replace with actual image
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())

                Text("Provider Name")
                    .font(.subheadline)
                Image("BlueTickIcon")
                    .foregroundColor(.blue)
                    .font(.caption2)

                Spacer()
                
                Button(action: {
                    followAction()
                }) {
                    Text(provider.isFollowing ? "Following" : "Follow")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .frame(width: 121, height: 31)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8)
                }
            }

            // Dropdown
            DisclosureGroup("Additional Info.", isExpanded: $showInfo) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(provider.description)
                    .padding(.bottom, 8)
                    HStack{
                        Image("Phone2")
                            .frame(width: 15, height: 15)
                        Text("Phone: ")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(provider.phone)")
                    }
                    .padding(.trailing, 10)
                    .padding(.leading, 10)
                    
                    HStack{
                        Image("WebsiteIcon")
                            .frame(width: 15, height: 15)
                        Text("Website: ")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(provider.website)")
                            .foregroundColor(Color(hex: "#258694"))
                            .underline()
                    }
                    .padding(.trailing, 10)
                    .padding(.leading, 10)
                    
                    HStack{
                        Image("LocationIcon")
                            .frame(width: 15, height: 15)
                        Text("Address: ")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(provider.address)")
                    }
                    .padding(.trailing, 10)
                    .padding(.leading, 10)
                    }
                
                .font(.caption)
            }
            //.padding()
            .padding(.top, 8)
            .padding(.bottom, 8)
            .padding(.leading, 12)
            .padding(.trailing, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "#258694"), lineWidth: 1)
            )
            .accentColor(Color(hex: "#258694"))
            //.padding(.horizontal, 24)
        }
        .padding()
        //.padding(.trailing, 24)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
      }
  }
