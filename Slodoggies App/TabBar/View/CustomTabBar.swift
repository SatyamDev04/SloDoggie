//
//  CustomTabBar.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//


import SwiftUI

enum CustomTab {
    case home, discover, add, services, profile
}

struct CustomTabBar: View {
    @EnvironmentObject var tabRouter: TabRouter

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#258694"))
                .frame(height: 65)
                .offset(y: -20)
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.white)
                .frame(height: 50)

            HStack {
                tabButton(.home, selectedImage: "HomeSelected", unselectedImage: "HomeUnselected", label: "Home")
                    .padding(10)
                tabButton(.discover, selectedImage: "DiscoverSelected", unselectedImage: "DiscoverUnselected", label: "Discover")
                    .padding(10)
                Spacer()

                tabButton(.services, selectedImage: "ServicesSelected", unselectedImage: "ServicesUnselected", label: "Services")
                    .padding(10)
                tabButton(.profile, selectedImage: "ProfileSelected", unselectedImage: "ProfileUnselected", label: "Profile")
                    .padding(10)
            }
            .padding(.horizontal)

            // Middle tab
            Button(action: {
                tabRouter.selectedTab = .add
                tabRouter.isTabBarHidden = true   // Hide tab bar
            }) {
                Image("PawTab")
                    .frame(width: 40, height: 40)
            }
            .offset(y: -10)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private func tabButton(_ tab: CustomTab, selectedImage: String, unselectedImage: String, label: String) -> some View {
        Button(action: {
            tabRouter.selectedTab = tab
            tabRouter.isTabBarHidden = false   // Show tab bar for normal tabs
        }) {
            VStack(spacing: 4) {
                Image(tabRouter.selectedTab == tab ? selectedImage : unselectedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)

                Text(label)
                    .font(tabRouter.selectedTab == tab ? .custom("Outfit-Medium", size: 12) : .custom("Outfit-Regular", size: 12))
                    .foregroundColor(tabRouter.selectedTab == tab ? Color(hex: "#258694") : .gray)
            }
        }
    }
}

#Preview {
    CustomTabBar()
}
