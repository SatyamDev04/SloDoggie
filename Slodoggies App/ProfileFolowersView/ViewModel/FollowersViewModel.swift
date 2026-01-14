//
//  FollowersViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import Foundation
import Combine
 
// MARK: - Followers ViewModel
final class FollowersViewModel: ObservableObject {
 
    // MARK: - DATA
    @Published var followers: [FollowersList] = []
    @Published var following: [FollowersList] = []
 
    // MARK: - COUNTS
    @Published var followersCount: String = ""
    @Published var followingCount: String = ""
 
    // MARK: - PAGINATION
    private var followersPage: Int = 1
    private var followingPage: Int = 1
 
    private var followersTotalPage: Int = 1
    private var followingTotalPage: Int = 1
 
    // MARK: - UI STATE
    @Published var searchText: String = ""
    @Published var selectedTab: Tab = .followers
    @Published var isLoadingMore: Bool = false
 
    @Published var showError: Bool = false
    @Published var errorMessage: String?
    
    @Published var isLoading: Bool = false
 
    private var cancellables = Set<AnyCancellable>()
 
    // MARK: - TABS
    enum Tab {
        case followers
        case following
    }
 
    // MARK: - FILTERED USERS
    var filteredUsers: [FollowersList] {
        let list = selectedTab == .followers ? followers : following
 
        guard !searchText.isEmpty else { return list }
 
        return list.filter {
            ($0.name ?? "")
                .localizedCaseInsensitiveContains(searchText)
        }
    }
 
    // MARK: - INIT
    init() {}
}
 
extension FollowersViewModel {
 
    func loadInitialData(userID:String) {
 
        isLoadingMore = false
 
        switch selectedTab {
 
        case .followers:
            followers.removeAll()
            followersPage = 1
            followersTotalPage = 1
            getFollowers(userID: userID, page: followersPage)
 
        case .following:
            following.removeAll()
            followingPage = 1
            followingTotalPage = 1
            getFollowing(userID: userID, page: followingPage)
        }
    }
}
 
extension FollowersViewModel {
 
    func getFollowers(userID:String, page: Int) {
        guard !isLoadingMore else { return }
        guard page <= followersTotalPage else { return }
 
        if page == 1 {
            isLoading = true
        } else {
            isLoadingMore = true
        }
 
        APIManager.shared.getFollowersListApi(id: userID, page: "\(page)",search: searchText)
        .receive(on: DispatchQueue.main)
        .sink { completion in
 
            self.isLoading = false
            self.isLoadingMore = false
 
            if case .failure(let error) = completion {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
 
        } receiveValue: { response in
            guard response.success == true else { return }
 
            let data = response.data
 
            self.followersTotalPage = data?.totalPage ?? 1
            self.followersCount = "\(data?.totalFollowers ?? 0)"
            self.followingCount = "\(data?.totalFollowing ?? 0)"
 
            if page == 1 {
                self.followers = data?.data ?? []
            } else {
                self.followers.append(contentsOf: data?.data ?? [])
            }
 
            self.followersPage += 1
        }
        .store(in: &cancellables)
    }
    
    
    func getFollowing(userID:String, page: Int) {
        guard !isLoadingMore else { return }
        guard page <= followingTotalPage else { return }
 
        if page == 1 {
            isLoading = true
        } else {
            isLoadingMore = true
        }
 
        APIManager.shared.getFollowingListApi(
            id: userID,
            page: "\(page)",
            search: searchText
        )
        .receive(on: DispatchQueue.main)
        .sink { completion in
 
            self.isLoading = false
            self.isLoadingMore = false
 
            if case .failure(let error) = completion {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
 
        } receiveValue: { response in
            guard response.success == true else { return }
 
            let data = response.data
 
            self.followingTotalPage = data?.totalPage ?? 1
            self.followersCount = "\(data?.totalFollowers ?? 0)"
            self.followingCount = "\(data?.totalFollowing ?? 0)"
 
            if page == 1 {
                self.following = data?.data ?? []
            } else {
                self.following.append(contentsOf: data?.data ?? [])
            }
 
            self.followingPage += 1
        }
        .store(in: &cancellables)
    }
    
    func removeFollowingApi(followedID: String, types: String, onSuccess: @escaping () -> Void) {
        
        isLoading = true
        APIManager.shared.removeFollowerFollowingApi(followedid: followedID, types: types)
          
        .receive(on: DispatchQueue.main)
        .sink { completion in
 
            self.isLoading = false
            
            if case .failure(let error) = completion {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
 
        } receiveValue: { response in
            guard response.success == true else { return }
            
            onSuccess()
 
        }
        .store(in: &cancellables)
    }
    
//    func removeUserLocally(userId: Int) {
//        if selectedTab == .followers {
//            followers.removeAll { $0.id == userId }
//        } else {
//            following.removeAll { $0.id == userId }
//        }
//    }
    
    func removeUserLocally(userId: Int) {
 
        if selectedTab == .followers {
            followers.removeAll { $0.id == userId }
 
            // ✅ UPDATE COUNT
            if let count = Int(followersCount), count > 0 {
                followersCount = "\(count - 1)"
            }
 
        } else {
            following.removeAll { $0.id == userId }
 
            // ✅ UPDATE COUNT
            if let count = Int(followingCount), count > 0 {
                followingCount = "\(count - 1)"
            }
        }
    }
 
    func loadMoreIfNeeded(userID: String, currentItem item: FollowersList) {
 
        switch selectedTab {
 
        case .followers:
            guard followers.last?.id == item.id else { return }
            getFollowers(userID: userID, page: followersPage)
 
        case .following:
            guard following.last?.id == item.id else { return }
            getFollowing(userID: userID, page: followingPage)
        }
    }
 
}

