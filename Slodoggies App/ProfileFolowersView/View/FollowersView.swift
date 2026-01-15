//
//  FollowersViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI
 
struct FollowersScreenView: View {
    let userID: String
    @StateObject private var viewModel = FollowersViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showRemovePopup = false
    @State private var selectedUser: FollowersList? = nil
    @State private var showToast = false
    @State private var toastMessage = ""
    
    private let initialTab: FollowersViewModel.Tab
    
    init(Id:String, initialTab: FollowersViewModel.Tab) {
        self.initialTab = initialTab
        self.userID = Id
    }
    
    var body: some View {
        ZStack{
            VStack {
                
                HeaderView()
                    .environmentObject(coordinator)
                
                TabsView(uId: userID, selectedTab: $viewModel.selectedTab,viewModel: viewModel)
                
                SearchBar(text: $viewModel.searchText)
                
//                UserList(
//                    viewModel: viewModel,
//                    onMessage: { coordinator.push(.chatView) },
//                    onRemove: { user in
//                        selectedUser = user
//                        showRemovePopup = true
//                    }
//                )
                ZStack {
                    if (viewModel.selectedTab == .followers && viewModel.followersCount == "0") ||
                       (viewModel.selectedTab == .following && viewModel.followingCount == "0") {

                        NoDataFoundView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.clear)

                    } else {
                        UserList(
                            uID: userID,
                            viewModel: viewModel,
                            onMessage: { coordinator.push(.chatView) },
                            onRemove: { user in
                                selectedUser = user
                                showRemovePopup = true
                            }
                        )
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)


            }
            .onAppear {
//                viewModel.selectedTab = initialTab
//                if viewModel.followers.isEmpty && viewModel.following.isEmpty {
//                    viewModel.loadInitialData()
//                }
                viewModel.selectedTab = initialTab
                viewModel.loadInitialData(userID: userID)
            }
 
            .navigationBarHidden(true)
            .overlay(removePopup)
            //.overlay(toastOverlay)
            
//            if viewModel.isLoadingMore {
//                CustomLoderView(isVisible: $viewModel.showActivity)
//                    .ignoresSafeArea()
//            }
            // LOADER OVERLAY
            if viewModel.isLoading {
                CustomLoderView(isVisible: $viewModel.isLoading)
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
        
        
    }
}
 
struct HeaderView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        HStack(spacing: 20) {
            Button { coordinator.pop() } label: {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Text("My Profile")
                .font(.custom("Outfit-Medium", size: 22))
            
            Spacer()
            
            Button {
                let userType = UserDefaults.standard.string(forKey: "userType")
                coordinator.push(userType == "Professional" ? .busiSettingsView : .settingView)
            } label: {
                Image("SettingIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal)
        
        Divider()
            .frame(height: 2)
            .background(Color(hex: "#258694"))
    }
}
 
struct TabsView: View {
    var uId: String
    @Binding var selectedTab: FollowersViewModel.Tab
    @ObservedObject var viewModel: FollowersViewModel
 
    var body: some View {
        HStack {
 
            // FOLLOWERS
            Button {
                guard selectedTab != .followers else { return }
 
                selectedTab = .followers
                viewModel.selectedTab = .followers
 
                // ✅ CLEAR SEARCH
                hideKeyboard()
                viewModel.searchText = ""
 
                // ✅ RELOAD
                viewModel.loadInitialData(userID: uId)
 
            } label: {
                Text("\(viewModel.followersCount) Followers")
                    .frame(maxWidth: .infinity, minHeight: 36)
                    .background(selectedTab == .followers ? Color(hex: "#258694") : .white)
                    .foregroundColor(selectedTab == .followers ? .white : .primary)
                    .cornerRadius(8)
            }
 
            // FOLLOWING
            Button {
                guard selectedTab != .following else { return }
 
                selectedTab = .following
                viewModel.selectedTab = .following
 
                // ✅ CLEAR SEARCH
                hideKeyboard()
                viewModel.searchText = ""
 
                // ✅ RELOAD
                viewModel.loadInitialData(userID: uId)
 
            } label: {
                Text("\(viewModel.followingCount) Following")
                    .frame(maxWidth: .infinity, minHeight: 36)
                    .background(selectedTab == .following ? Color(hex: "#258694") : .white)
                    .foregroundColor(selectedTab == .following ? .white : .primary)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
        .padding(.top, 10)
    }
}
 
import SwiftUI
 
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
 
 
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image("Search")
                .resizable()
                .frame(width: 15, height: 15)
                .padding(.leading, 14)
            
            TextField("Search", text: $text)
                .padding(10)
        }
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .padding()
    }
}
 
struct UserList: View {
    var uID: String
    @ObservedObject var viewModel: FollowersViewModel
    var onMessage: () -> Void
    var onRemove: (FollowersList) -> Void
    
    var body: some View {
        List {
            ForEach(viewModel.filteredUsers, id: \.id) { user in
                FollowerRow(
                    user: user,
                    isFollowersTab: viewModel.selectedTab == .followers,
                    onMessage: onMessage,
                    onRemove: { onRemove(user) }
                )
                .onAppear {
                    viewModel.loadMoreIfNeeded(userID: uID, currentItem: user)
                }
            }
            .listRowSeparator(.hidden)
            
            if viewModel.isLoadingMore {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}
 
struct FollowerRow: View {
    let user: FollowersList
    let isFollowersTab: Bool
    var onMessage: () -> Void
    var onRemove: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                if (user.profilePic != "") {
                    Image.loadImage(user.profilePic, width: 42, height: 42)
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image("download")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                }
//                Image(user.profilePic ?? "")
//                    .resizable()
//                    .frame(width: 42, height: 42)
//                    .clipShape(Circle())
//
                VStack(alignment: .leading) {
                    Text(user.name ?? "")
                        .font(.custom("Outfit-Medium", size: 15))
                }
                
                Spacer()
                
                if isFollowersTab {
                    if user.isFollowing ?? false{
                        Button("Message") {
                            onMessage()
                        }
                        .padding()
                        .frame(height: 31)
                        .foregroundColor(Color(hex: "#258694"))
                        .font(.custom("Outfit-Regular", size: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(hex: "#258694"), lineWidth: 1)
                        )
                    } else {
                        Button("Follow Back") {
                            
                        }
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
                    Button("Message") {
                        onMessage()
                    }
                    .padding()
                    .frame(height: 31)
                    .foregroundColor(Color(hex: "#258694"))
                    .font(.custom("Outfit-Regular", size: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(hex: "#258694"), lineWidth: 1)
                    )
                }
                
                Button(action: onRemove) {
                    Image("cancelBtnIcon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
    //        .padding(.vertical, 8)
            
            Divider()
                .background(Color(hex: "#F2F2F2")).opacity(0.10)
                .padding(.top, 10)
        }
    }
}
 
 
extension FollowersScreenView {
 
    var removePopup: some View {
        Group {
            if showRemovePopup, let user = selectedUser {
 
                RemoveFollowerPopUp(
                    isVisible: $showRemovePopup,
                    tabType: viewModel.selectedTab,
                    backAction: {
                        selectedUser = nil
                    },
                    onRemove: {
 
                        let userId = "\(user.id ?? 0)"
                        let type = viewModel.selectedTab == .followers
                                   ? "follower"
                                   : "following"
 
                        viewModel.removeFollowingApi(
                            followedID: userId,
                            types: type
                        ) {
 
                            // ✅ REMOVE ONLY AFTER API SUCCESS
                            viewModel.removeUserLocally(userId: user.id ?? 0)
 
                            toastMessage = type == "followers"
                                           ? "Removed"
                                           : "Unfollowed"
 
                            showToast = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showToast = false
                            }
 
                            selectedUser = nil
                        }
                    }
                )
            }
        }
    }
}


struct NoDataFoundView: View {
    var body: some View {
        VStack() {
            
            Image("DummyIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(.top, -125)

            Text("No Data Found")
                .font(.custom("Outfit-Medium", size: 18))
                .foregroundColor(.gray)
                .padding(.top, -65)
        }
    }
}
