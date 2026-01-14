
//
//  BusiProfileView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import SwiftUI

struct BusiProfileView: View {

    let comesFrom : String
    let businessID : String
    @StateObject private var viewModel = BusiProfileViewModal()
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var tabRouter: TabRouter
    @EnvironmentObject var userData: UserData

    @State private var showAddPetSheet = false
    var hideSponsoredButton: Bool = false
    
    @State private var shouldRefreshProfile = false

    var body: some View {

        ZStack {
            VStack(spacing: 0) {

                // HEADER
                VStack(alignment: .leading, spacing: 16) {
                    HStack(spacing: 20) {
                        Button {
                            if hideSponsoredButton {
                                coordinator.pop()
                            } else {
                                tabRouter.selectedTab = .home
                            }
                        } label: {
                            Image("Back")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        Text(comesFrom == "Tab" ? "My Profile" : "Profile")
                            .font(.custom("Outfit-Medium", size: 22))
                            .foregroundColor(Color(hex: "#221B22"))

                        Spacer()

                        Button {
                            let userType = UserDefaults.standard.string(forKey: "userType")
                            if userType == "Professional" {
                                coordinator.push(.busiSettingsView)
                            } else {
                                coordinator.push(.settingView)
                            }
                        } label: {
                            Image("SettingIcon")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    .padding(.horizontal, 20)

                    Divider()
                        .frame(height: 2)
                        .background(Color(hex: "#258694"))
                }

                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 16) {

                        if viewModel.isProfileLoading {
                            BusiProfileSkeletonView()
                            BusiStatsSkeletonView()
                        } else if let selected = viewModel.Busiuser {
                            BusiPersonCardView(pet: selected)
                            BusiStatsView(pet: selected)
                        }

                        if viewModel.isProfileLoading {
                            SponsoredButtonSkeleton()
                        } else if !hideSponsoredButton {
                            Button {
                                coordinator.push(.adsDashboardView)
                            } label: {
                                Text("Sponsored Ads Dashboard")
                                    .foregroundColor(Color(hex: "#258694"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(hex: "#258694"), lineWidth: 1)
                            )
                            .padding(.horizontal, 20)
                        }


                        Text("Gallery")
                            .font(.custom("Outfit-Medium", size: 16))
                            .padding(.leading)

                        Divider()
                            .background(Color(hex: "#949494"))
                            .padding(.horizontal, 20)

                        if viewModel.isGalleryLoading && viewModel.BusigalleryItems.isEmpty {
                            BusiGallerySkeletonView()
                                
                        }
                        else if viewModel.BusigalleryItems.isEmpty {
                            VStack(spacing: 10) {
                                Image("DogFoot")
                                    .resizable()
                                    .frame(width: 60, height: 60)

                                Text("No Post Yet").bold()

                                if businessID == UserDetail.shared.getUserId(){
                                    Button("Create Post") { }
                                        .foregroundColor(.teal)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                        }
                        else {
                            BusiGalleryGridView(
                                viewModel: viewModel,
                                items: viewModel.BusigalleryItems,
                                onSelect: { index in
                                    shouldRefreshProfile = true
                                    coordinator.push(.savedPostsView(comesFrom == "Tab" ? UserDetail.shared.getUserId() : businessID,"MyProfile"))
                                },
                                onLoadMore: {
                                    viewModel.getBussinessGalleryApi(userId: self.businessID)
                                }
                            )
                            .padding(.bottom, 30)
                            .padding(.horizontal, 20)
                        }
                    }
                    .padding(.top)
                }
            }
            .onAppear {
                shouldRefreshProfile = false
                // Call BOTH APIs
                viewModel.getBussinessProfile(userID: self.businessID)
                viewModel.getBussinessGalleryApi(userId: self.businessID, reset: true)
//                if shouldRefreshProfile {
//                    shouldRefreshProfile = false
//                    // Call BOTH APIs
//                    viewModel.getBussinessProfile(userID: self.businessID)
//                    viewModel.getBussinessGalleryApi(userId: self.businessID, reset: true)
//                } else {
//                    // First time load
//                    viewModel.getBussinessProfile(userID: self.businessID)
//                    viewModel.getBussinessGalleryApi(userId: self.businessID,reset: true)
//                }
            }

            // LOADER OVERLAY
//            if viewModel.isLoading {
//                CustomLoderView(isVisible: $viewModel.isLoading)
//                    .ignoresSafeArea()
//            }
        }
    }
}
#Preview {
    BusiProfileView(comesFrom: "", businessID: "")
}

struct BusiProfileSkeletonView: View {
    var body: some View {
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
                        .frame(width: 140, height: 14)

                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 14)
                }
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
        .shadow(radius: 2)
        .padding(.horizontal)
        .redacted(reason: .placeholder)
    }
}

struct BusiStatsSkeletonView: View {
    var body: some View {
        HStack {
            skeletonBlock
            Divider()
            skeletonBlock
            Divider()
            skeletonBlock
        }
        .padding()
        .redacted(reason: .placeholder)
    }

    private var skeletonBlock: some View {
        VStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 16)

            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 14)
        }
        .frame(maxWidth: .infinity)
    }
}
struct SponsoredButtonSkeleton: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.3))
            .frame(height: 44)
            .padding(.horizontal, 20)
            .redacted(reason: .placeholder)
    }
}
struct BusiGallerySkeletonView: View {
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<9, id: \.self) { _ in
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 135)
            }
        }
        .padding(.horizontal)
        .redacted(reason: .placeholder)
    }
}

