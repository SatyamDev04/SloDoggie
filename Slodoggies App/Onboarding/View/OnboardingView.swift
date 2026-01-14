//
//  OnboardingPage.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/07/25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $currentPage) {
                ForEach(onboardingData.indices, id: \.self) { index in
                    OnboardingCard(
                        page: onboardingData[index],
                        currentPage: index,
                        totalPages: onboardingData.count
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .frame(height: UIScreen.main.bounds.height * 0.75)
            .ignoresSafeArea(.all)
//            .ignoresSafeArea(edges: .top)
//            .ignoresSafeArea(.container, edges: .top)
//            .padding(.top, 10)

            VStack(spacing: 12) {
                // Primary Button
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        currentPage += 1
                    } else {
                        coordinator.push(.joinAs)
                    }
                }) {
                    Text(onboardingData[currentPage].buttonTitle)
                        .font(.custom("Outfit-SemiBold", size: 18))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#258694"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                // Always reserve space for Skip
                if currentPage < onboardingData.count - 1 {
                    Button("Skip") {
                        coordinator.push(.joinAs)
                    }
                    .foregroundColor(Color(hex: "#949494"))
                } else {
                    // invisible placeholder to keep spacing same
                    Color.clear
                        .frame(height: 24)
                }
            }
            .padding(.horizontal, 30)
            .padding(.bottom, 30)

        }
    }
}

struct OnboardingCard: View {
    let page: OnboardingPage
    let currentPage: Int
    let totalPages: Int

    var body: some View {
        VStack(spacing: 0) {
            Image(page.image)
                .resizable()
                .scaledToFill()
                .frame(height: 520)
                .clipped()

            ZStack(alignment: .topTrailing) {
                VStack(spacing: 16) {
                    // Pagination Dots
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Rectangle()
                                .fill(index == currentPage ? Color(hex: "#258694") : Color.white.opacity(0.3))
                                .frame(width: 17, height: 6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 3)
                                        .stroke(Color(hex: "#949494"), lineWidth: 1) // Border color + thickness
                                )
                                .cornerRadius(3)
                        }
                    }

                    // Title
                    Text(page.title)
                        .font(.custom("Outfit-Bold", size: 24))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    // Subtitle
                    Text(page.subtitle)
                        .font(.custom("Outfit-Regular", size: 18))
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal, 24)
                }
                .padding(.vertical, 30)
                .padding(.top, 12)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
//                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -2)

//                // Optional Badge (like top-right floating image)
//                Image("yourBadgeImage") // replace with real image
//                    .resizable()
//                    .frame(width: 40, height: 40)
//                    .offset(x: -20, y: -20)
            }
            .offset(y: -40)
        }
        .padding(.top, -80)
    }
}

#Preview{
    OnboardingView()
}
