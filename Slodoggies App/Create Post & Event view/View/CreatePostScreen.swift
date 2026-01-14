//
//  CreateGroup&EventView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import SwiftUI

struct CreatePostScreen: View {
    @StateObject private var viewModel = CreatePostViewModel()
    @StateObject private var petAddViewModel = PetInfoViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var titleName = ""
    @EnvironmentObject var tabRouter: TabRouter
    @State private var showPostSuccessPopView: Bool = false
    @State private var showEventSuccessPopView: Bool = false
    @State private var showAddPetSheet: Bool = false
    @State private var showAddressSheet: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                // Toggle
                HStack(spacing: 10){
                    Button(action: {
                        tabRouter.selectedTab = .home   // Back to Home
                        tabRouter.isTabBarHidden = false
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    Text(viewModel.selectedTab == .post ? "New Post" : "New Event")
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                ScrollView {
                    HStack(spacing: 0) {
                        Button(action: {
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
                        Button(action: { viewModel.selectedTab = .event }) {
                            Text("Event")
                                .foregroundColor(viewModel.selectedTab == .event ? .white : .black)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .frame(height: 34)
                                .background(viewModel.selectedTab == .event ? Color(hex: "#258694") : Color.white)
                                .cornerRadius(6)
                        }
                    }
                    .padding(.top, 40)
                    .frame(height: 24)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    if viewModel.selectedTab == .post {
                        PostFormView(pets: $viewModel.petsArr,
                                     backAction: { postDetails in
                            viewModel.postData = postDetails
                            viewModel.createPostApi() { success in
                                if success{
                                    showPostSuccessPopView = true
                                }
                            }
                        },onPetAddBtnTap: {
                            showAddPetSheet = true
                        },errorHandler: { msg in
                            viewModel.showError = true
                            viewModel.errorMessage = msg
                        })
                    } else {
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
                        }) // <-- pass binding
                    }
                }
                //.padding(.top, 40)
            }
            // Popup overlay
            if showPostSuccessPopView {
                PostCreatedSuccPopUp(isVisible: $showPostSuccessPopView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4)) // dim background
                    .ignoresSafeArea() // full screen
                    .transition(.opacity)
            }
            if showEventSuccessPopView {
                EventCreatedSuccPopUp(isVisible: $showEventSuccessPopView)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4)) // dim background
                    .ignoresSafeArea() // full screen
                    .transition(.opacity)
            }
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
            if showAddPetSheet {
                PetInfoPopupView(pets: viewModel.petsArr,backAction:  {
                    showAddPetSheet = false
                }, comesFrom: "TabBar")
            }
        }
        .onAppear(){
            viewModel.getPetListApi()
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
   CreatePostScreen()
}
