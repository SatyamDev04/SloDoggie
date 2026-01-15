//
//  BusiCreatePostEventView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI

struct BusiCreatePostEventView: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @StateObject private var adsViewModel = BusiAdsViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject var tabRouter: TabRouter

    @State private var BusiPostsCreatedPopup: Bool = false
    @State private var showEventSuccessPopView: Bool = false
    @State private var showAddressSheet: Bool = false
    
    var body: some View {
        ZStack{
            VStack {
                // Header
                HStack(spacing: 10){
                    Button(action: {
                        tabRouter.selectedTab = .home   // Back to Home
                        tabRouter.isTabBarHidden = false
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text(viewModel.selectedTab.title)
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    Spacer()
                }
                .padding(.horizontal, 20)

                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))

                // Content
                ScrollView {
                    HStack(spacing: 0) {
                        Button(action: {
                            viewModel.selectedMedia.removeAll()
                            viewModel.pickerItems.removeAll()
                            viewModel.selectedTab = .post
                            
                        }) {
                            Text("Post")
                                .foregroundColor(viewModel.selectedTab == .post ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(viewModel.selectedTab == .post ? Color(hex: "#258694") : Color.white)
                                .cornerRadius(6)
                        }

                        Button(action: {
                            viewModel.selectedMedia.removeAll()
                            viewModel.pickerItems.removeAll()
                            viewModel.selectedTab = .event }) {
                            Text("Event")
                                .foregroundColor(viewModel.selectedTab == .event ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(viewModel.selectedTab == .event ? Color(hex: "#258694") : Color.white)
                                .cornerRadius(6)
                        }

                        Button(action: {
                            viewModel.selectedMedia.removeAll()
                            viewModel.pickerItems.removeAll()
                            viewModel.selectedTab = .ads }) {
                            Text("Ads.")
                                .foregroundColor(viewModel.selectedTab == .ads ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(viewModel.selectedTab == .ads ? Color(hex: "#258694") : Color.white)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.top, 40)
                    .frame(height: 24)
                    .padding(.horizontal)
                    .padding(.bottom)

                    // Switch tabs
                    if viewModel.selectedTab == .post {
//                        BusiPostFormView(showBusiPostSuccessPopView: $BusiPostsCreatedPopup)
                        
                        PostFormView(pets: .constant([PetsDetailData]()),
                                     backAction: { postDetails in
                            viewModel.postData = postDetails
                            viewModel.createPostApi() { success in
                                if success{
                                    BusiPostsCreatedPopup = true
                                }
                            }
                        },onPetAddBtnTap: {},errorHandler: { msg in
                            viewModel.showError = true
                            viewModel.errorMessage = msg
                        })
                    } else if viewModel.selectedTab == .event {
//                        BusiEventFormView(showEventSuccessPopView: $showEventSuccessPopView)
                        EventFormView(showEventSuccessPopView: $showEventSuccessPopView, viewModel: viewModel,backAction: { eventDetail in
                            viewModel.eventData = eventDetail
                            viewModel.createEventApi { success in
                                if success {
                                    showEventSuccessPopView = true
                                }
                            }
                        }, errorHandeler: { msg in
                            viewModel.showError = true
                            viewModel.errorMessage = msg
                        },onAddressTap: {
                            showAddressSheet = true
                        })
                    } else if viewModel.selectedTab == .ads {
                        BusiAdsFormView(errorHandler: { msg in
                            viewModel.showError = true
                            viewModel.errorMessage = msg
                        }, viewModel: viewModel,addressTap: {
                            showAddressSheet = true
                        })
                        .onAppear(){
                            viewModel.GetServiceList()
                        }
                    }
                }
            }
            if BusiPostsCreatedPopup {
                BusiPostCreatedPopup(isVisible: $BusiPostsCreatedPopup)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                    .transition(.opacity)
            }

            if showEventSuccessPopView {
                EventCreatedSuccPopUp(isVisible: $showEventSuccessPopView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .ignoresSafeArea()
                    .transition(.opacity)
            }
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
        .sheet(isPresented: $showAddressSheet) {
            AddressSearchSheet { selectedAddress in
//                        viewModel.businessAddress = selectedAddress
                showAddressSheet = false
                viewModel.fillAddress(selectedAddress)
            }
        }
    }
}

#Preview {
    BusiCreatePostEventView()
}
