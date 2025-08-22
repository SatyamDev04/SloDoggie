//
//  FollowersViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI

struct FollowersScreenView: View {
    @StateObject private var viewModel = FollowersViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State var showremoveFollowerPopView: Bool = false
    @State private var selectedUser: UserModel? = nil
    @State private var showToast = false
    @State private var toastMessage = ""
    
    private let initialTab: FollowersViewModel.Tab

        init(initialTab: FollowersViewModel.Tab) {
            self.initialTab = initialTab
        }
    
    var body: some View {
        VStack {
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("My Profile")
                    .font(.custom("Outfit-Medium", size: 22))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
                
                Spacer()
                
                Button(action: {
                    coordinator.push(.settingView)
                }){
                    Image("SettingIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.leading, 18)
            .padding(.trailing, 25)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#656565"))
            // Top Tabs
            HStack {
                Button(action: { viewModel.selectedTab = .followers }) {
                    Text("27.7 M Followers")
                        .padding()
                        .frame(height: 36)
                        .font(.custom("Outfit-Regular", size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewModel.selectedTab == .followers ? .white : .primary)
                        .background(viewModel.selectedTab == .followers ? Color(hex: "#258694") : Color.white)
                        .cornerRadius(8)
                }
                
                Button(action: { viewModel.selectedTab = .following }) {
                    Text("219 Following")
                        .padding()
                        .frame(height: 36)
                        .font(.custom("Outfit-Regular", size: 14))
                        .frame(maxWidth: .infinity)
                        .foregroundColor(viewModel.selectedTab == .following ? .white : .primary)
                        .background(viewModel.selectedTab == .following ? Color(hex: "#258694") : Color.white)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.top, 15)
            //.padding(.bottom, 12)
            
            // Search Bar
            
            HStack{
                Image("Search")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .padding(.leading, 14)
                
                TextField("Search", text: $viewModel.searchText)
                    .padding(10)
                //.background(Color.gray.opacity(0.1))
                //.cornerRadius(8)
                //.padding(.horizontal)
            }
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
            .padding()
            
            // User List
            List {
                ForEach(viewModel.filteredUsers) { user in
                    VStack(spacing: 0) {
                        HStack {
                            Image(user.profileImage)
                                .resizable()
                                .frame(width: 42, height: 42)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(user.name)
                                        .font(.custom("Outfit-Medium", size: 15))
                                    if user.isVerified {
                                        Image("BlueTickIcon")
                                    }
                                }
                            }
                            
                            Spacer()
                            
                            if viewModel.selectedTab == .followers {
                                if user.isFollowBack {
                                    Button("Follow Back") { }
                                        .padding()
                                        .frame(height: 31)
                                        .foregroundColor(Color(hex: "#258694"))
                                        .font(.custom("Outfit-Regular", size: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color(hex: "#258694"), lineWidth: 1)
                                        )
                                } else {
                                    Button("Message") { }
                                        .padding()
                                        .frame(height: 31)
                                        .foregroundColor(Color(hex: "#258694"))
                                        .font(.custom("Outfit-Regular", size: 12))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(Color(hex: "#258694"), lineWidth: 1)
                                        )
                                }
                            } else {
                                Button("Message") { }
                                    .padding()
                                    .frame(height: 31)
                                    .foregroundColor(Color(hex: "#258694"))
                                    .font(.custom("Outfit-Regular", size: 12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6)
                                            .stroke(Color(hex: "#258694"), lineWidth: 1)
                                    )
                            }
                            
                            Button(action: {
                                selectedUser = user
                                showremoveFollowerPopView = true
                            }) {
                                Image("cancelBtnIcon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.horizontal, 4)
                        .padding(.vertical, 5)
                        
                        Divider()
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(PlainListStyle())
        }
        .onAppear {
            // ✅ set tab when screen appears
            viewModel.selectedTab = initialTab
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .overlay(
            Group {
                if showremoveFollowerPopView {
                    RemoveFollowerPopUp(
                        isVisible: $showremoveFollowerPopView,
                        backAction: {
                            selectedUser = nil
                        },
                        onRemove: {
                            selectedUser = nil
                            toastMessage = " Removed "
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
                        }
                    )
                }
            }
        )
        .overlay(
            Group {
                if showToast {
                    ZStack {
                        // Background dimming
                        Color(hex: "#3C3C434A").opacity(0.5)
                            .ignoresSafeArea()
                        
                        Text(toastMessage)
                            .font(.custom("Outfit-Medium", size: 16))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 12)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .transition(.opacity)
                            .frame(width: 120, height: 30, alignment: .center)
                            .animation(.easeInOut, value: showToast)
                    }
                }
            }
        )
    }
}

   #Preview {
       FollowersScreenView(initialTab: .followers)
   }
