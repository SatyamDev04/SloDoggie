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
                        print("Navigate to home or login")
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

                // Conditionally show Skip without leaving space
                if currentPage < onboardingData.count - 1 {
                    Button("Skip") {
                        print("Skip pressed")
                        coordinator.push(.joinAs)
                    }
                    .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
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
                .frame(height: 480)
                .clipped()

            ZStack(alignment: .topTrailing) {
                VStack(spacing: 16) {
                    // Pagination Dots
                    HStack(spacing: 8) {
                        ForEach(0..<totalPages, id: \.self) { index in
                            Rectangle()
                                .fill(index == currentPage ? Color(hex: "#258694") : Color.gray.opacity(0.3))
                                .frame(width: 15, height: 6)
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
                        .font(.custom("Outfit-Regular", size: 17))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
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
            .offset(y: -100)
        }
    }
}

