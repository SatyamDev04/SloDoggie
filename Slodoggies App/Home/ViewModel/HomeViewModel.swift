//
//  HomeViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.

import Foundation
import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    // MARK: - UI States
    @Published var showWelcomPopUp: Bool = true
    @Published var isLoading: Bool = false
    @Published var showActivity = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = ""
    @Published var showComments: Bool = false
    @Published var showPostReportPopUp: Bool = false
    @Published var reportFor: String?
    @Published var showToast: Bool = false

    // MARK: - Pagination
    @Published var page: Int = 1
    @Published var limit: Int = 20
    @Published var totalPages: Int = 1
    @Published var isPaginating: Bool = false

    // MARK: - Data
    @Published var homeDataResult: HomeModel?
    @Published var editPostResult: EditPostModel?
    @Published var feedItems: [HomeItem] = []
    
    @Published var myPostResult: MyPostModel?
    @Published var MyPostItem: [MyPostItem] = []
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Home API
    func homeDataApi(isLoadMore: Bool = false) {

        guard !isPaginating else { return }

        isPaginating = true
        showActivity = page == 1

        APIManager.shared.HomeDataApi(page: page, limit: limit)
            .sink { completion in
                self.showActivity = false
                self.isPaginating = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in

                guard response.success == true else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    return
                }

                let newItems = response.data?.items ?? []

                self.totalPages = response.data?.totalPage ?? 1

                if isLoadMore {
                    self.feedItems.append(contentsOf: newItems)
                } else {
                    self.feedItems = newItems
                }
            }
            .store(in: &cancellables)
    }
    
  
    // MARK: - Pagination Trigger
    func loadMoreIfNeeded(currentIndex: Int) {
        guard currentIndex == feedItems.count - 1 else { return }
        guard page < totalPages else { return }

        page += 1
        homeDataApi(isLoadMore: true)
    }
    
    
    // MARK: - Home API
    func getMySavedPostApi(isLoadMore: Bool = false) {

        guard !isPaginating else { return }

        isPaginating = true
        showActivity = page == 1

        APIManager.shared.mySavedPostApi(page: page, limit: limit)
            .sink { completion in
                self.showActivity = false
                self.isPaginating = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in

                guard response.success == true else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    return
                }

                let newItems = response.data?.items ?? []
                self.totalPages = response.data?.totalPage ?? 1
                if isLoadMore {
                    self.feedItems.append(contentsOf: newItems)
                } else {
                    self.feedItems = newItems
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Pagination Trigger
    func loadMoreIfNeededMySavedPost(currentIndex: Int) {
        guard currentIndex == feedItems.count - 1 else { return }
        guard page < totalPages else { return }

        page += 1
        getMySavedPostApi(isLoadMore: true)
    }
    
    // MARK: - Home API
    
    func getMyPostApi(UserID: String,isLoadMore: Bool = false) {

        if !isLoadMore {
            page = 1
            feedItems.removeAll()
        }

        guard !isPaginating else { return }

        isPaginating = true
        showActivity = page == 1

        APIManager.shared.myPostApi(userID: UserID, page: page, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isPaginating = false
                self.showActivity = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                guard response.success == true else { return }

                self.myPostResult = response.data
                
                self.totalPages = response.data?.totalPage ?? 1

                if isLoadMore {
                    self.MyPostItem.append(contentsOf: self.myPostResult?.data ?? [])
                } else {
                    self.MyPostItem = self.myPostResult?.data ?? []
                }
                
                print(self.MyPostItem, "yahi value hai ")
            }
            .store(in: &cancellables)
    }

    // MARK: - Pagination Trigger
    func loadMoreIfNeededMyPost(userId: String,currentIndex: Int) {
        guard currentIndex == feedItems.count - 1 else { return }
        guard page < totalPages else { return }

        page += 1
        getMyPostApi(UserID: userId, isLoadMore: true)
    }

    // MARK: - Follow / Unfollow
    func FollowUnfollowApi(index: String, Index1: Int) {
        self.showActivity = true
        APIManager.shared.FollowUnfollowApi(followerID: index)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }
                let current = self.feedItems[Index1].itemsuccess?.iAmFollowing ?? false
                self.feedItems[Index1].itemsuccess?.iAmFollowing = !current
            }
            .store(in: &cancellables)
    }
    
 // MARK: - repostPostApi

    func repostPostApi(
        userid: String,
        postID: String,
        reportReason: String,
        text: String,
        completion: @escaping (Result<(Bool, String?), Error>) -> Void
    ) {
        showActivity = true

        APIManager.shared.repostPostApi(
            userid: userid,
            postId: postID,
            report_reason: reportReason,
            text: text
        )
        .receive(on: DispatchQueue.main)
        .sink { completionResult in
            self.showActivity = false

            if case .failure(let error) = completionResult {
                completion(.failure(error))
            }
        } receiveValue: { response in
            completion(.success((response.success ?? false, response.message)))
        }
        .store(in: &cancellables)
    }

    func updateCommentCount(postId: String, count: Int) {
        guard let index = feedItems.firstIndex(where: { $0.postID == postId }) else { return }

        feedItems[index].engagement?.comments = .integer(count)
    }

    // MARK: - Save / Unsave
    func SaveUnsaveApi(postId: String, Index1: Int, postType: String, comingFrom: String) {
        self.showActivity = true
        APIManager.shared.SaveUnsaveApi(postId: postId, postType: postType)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }
                if comingFrom == "myPost" {
                    let current = self.MyPostItem[Index1].itemSuccess?.isSaved ?? false
                    self.MyPostItem[Index1].itemSuccess?.isSaved = !current
                } else {
                    let current = self.feedItems[Index1].itemsuccess?.isSave ?? false
                    self.feedItems[Index1].itemsuccess?.isSave = !current }
            }
            .store(in: &cancellables)
    }

 
    // MARK: - Like / Unlike
    func likeUnlikeApi(postId: String, index: Int, postType: String, comingFrom: String) {
        showActivity = true

        APIManager.shared.LikeUnlikeApi(postId: postId, postType: postType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                self.showActivity = false
            } receiveValue: { response in
                guard response.success == true else { return }

                if comingFrom == "myPost" {

                    let isLiked = self.MyPostItem[index].itemSuccess?.isLiked ?? false
                    let currentLikes = self.MyPostItem[index].getPostLikeCount ?? 0

                    self.MyPostItem[index].itemSuccess?.isLiked = !isLiked
                    self.MyPostItem[index].getPostLikeCount =
                        isLiked ? max(currentLikes - 1, 0) : currentLikes + 1

                } else {

                    let isLiked = self.feedItems[index].itemsuccess?.isLiked ?? false
                                      let currentLikes = self.intValue(self.feedItems[index].engagement?.likes)
                  
                                      self.feedItems[index].itemsuccess?.isLiked = !isLiked
                                      self.feedItems[index].engagement?.likes = .integer(
                                          isLiked ? max(currentLikes - 1, 0) : currentLikes + 1
                                      )
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Delete Post
    func deletePostApi(postId: String, index: Int, comingFrom: String) {
        showActivity = true

        APIManager.shared.removePostApi(postID: postId)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                guard response.success == true else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Unable to delete post"
                    return
                }

                // Remove item locally after success
                if comingFrom == "myPost" {
                    guard self.MyPostItem.indices.contains(index) else { return }
                    self.MyPostItem.remove(at: index)
                } else {
                    guard self.feedItems.indices.contains(index) else { return }
                    self.feedItems.remove(at: index)
                }
            }
            .store(in: &cancellables)
    }
    
    func editPostApi(postId: String, text: String) {
        showActivity = true

        APIManager.shared.editPostApi(postID: postId, text: text)
        .receive(on: DispatchQueue.main)
        .sink { completion in
            self.showActivity = false

            if case .failure(let error) = completion {
                self.showError = true
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { response in
            if response.success == true {
                
                self.editPostResult = response.data
                
                // UPDATE LOCAL MY POST LIST
                          if let index = self.MyPostItem.firstIndex(where: {
                              "\($0.id ?? 0)" == postId
                          }) {
                              self.MyPostItem[index].postTitle = text
                          }
               
            }
        }
        .store(in: &cancellables)
    }

    private func intValue(_ value: Comments?) -> Int {
        switch value {
        case .integer(let v): return v
        case .string(let v): return Int(v) ?? 0
        default: return 0
        }
    }
    
    func resetPagination() {
        page = 1
        totalPages = 1
        feedItems.removeAll()
        isPaginating = false
    }
}
