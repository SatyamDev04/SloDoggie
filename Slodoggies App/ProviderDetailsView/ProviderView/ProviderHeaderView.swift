//
//  ProviderHeaderView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

// MARK: - Custom Disclosure (no default arrow)
struct CustomDisclosure<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(nil) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    // Title text teal
                    Text(title)
                        .foregroundColor(Color(hex: "#258694"))
                        .font(.custom("Outfit-SemiBold", size: 14))

                    Spacer()

                    // Arrow in teal also
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(Color(hex: "#258694"))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)

            if isExpanded {
                content()
                    .transition(.opacity.combined(with: .slide))
                    .padding(.bottom, 8)
                    .padding(.horizontal, 12)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(hex: "#258694"), lineWidth: 1)
        )
    }
}


// MARK: - ProviderHeaderView
struct ProviderHeaderView: View {
    let provider: BusinessServiceModel?
    let followAction: () -> Void
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showInfo = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                if let uiImage = provider?.profileImage {
                    AsyncImage(url: URL(string: uiImage)) { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                    } placeholder: {
                        ZStack{
                            Color.gray.opacity(0.2)
                                .frame(width: 55, height: 55)
                                .clipShape(Circle())
                            ProgressView()
                        }
                    }
                    
                } else {
                    Image("DummyIcon") // your default placeholder asset
                        .resizable()
                        .scaledToFill()
                        .frame(width: 55, height: 55)
                        .clipShape(Circle())
                }
                Spacer()

                Text(provider?.category?.first ?? "")
                    .font(.custom("Outfit-Medium", size: 10))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.white)
                    .foregroundColor(Color.gray)
                    .frame(width: 71 , height: 25)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
            }
            .padding(.trailing, 2)


            // Title & Rating & Buttons
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(provider?.businessName ?? "")
                            .font(.custom("Outfit-Medium", size: 14))
                        if provider?.verificationstatus ?? false{
                            Image("BlueTickIcon")
                                .foregroundColor(.blue)
                                .font(.caption2)
                        }
                    }
                    HStack(spacing: 4) {
                        Image("StarIcon")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text("\(provider?.rating ?? "")/5")
                            .font(.caption)
                    }
                }

                Spacer()

                VStack {
                    Button(action: {
                        coordinator.push(.chatView)
                    }) {
                        HStack(spacing: 6) {
                            Image("ChatIcon1")
                            Text("Inquire now")
                        }
                        .font(.custom("Outfit-SemiBold", size: 12))
                        .foregroundColor(Color(hex: "#258694"))
                        .padding(.horizontal, 8)
                        .frame(width: 121, height: 31)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#258694"), lineWidth: 1)
                        )
                    }
                    .padding(.top, 10)
                }
            }

            // Provider Info Row
            HStack(spacing: 6) {
                Text("Provider Name")
                    .font(.custom("Outfit-Medium", size: 14))

                Spacer()

                Button(action: {
                    followAction()
                }) {
                    Text(/*provider.isFollowing ? "Following" : */"Follow")
                        .font(.custom("Outfit-SemiBold", size: 12))
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .frame(width: 121, height: 31)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8)
                }
            }

            // Custom Dropdown (no default arrow)
            CustomDisclosure(title: "Additional Info.", isExpanded: $showInfo) {
                VStack(alignment: .leading, spacing: 12) {
                    (
                        Text("Business Description : ")
                            .font(.custom("Outfit-Medium", size: 12))
                        +
                        Text(provider?.businessDescription ?? "")
                            .font(.custom("Outfit-Regular", size: 12))
                    )
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 8)

                    HStack {
                        Image("Phone2")
                            .frame(width: 15, height: 15)
                        Text("Phone: ")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(provider?.phone ?? "")")
                    }
                    .padding(.horizontal, 10)

                    HStack {
                        Image("WebsiteIcon")
                            .frame(width: 15, height: 15)
                        Text("Website: ")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        Spacer()
                        Text("\(provider?.website ?? "")")
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
                        Text("\(provider?.address ?? "")")
                    }
                    .padding(.horizontal, 10)
                }
                .font(.caption)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
        .padding(.horizontal, 16)
    }
}
