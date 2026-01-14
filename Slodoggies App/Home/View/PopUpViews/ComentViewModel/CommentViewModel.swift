//
//  CommentViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 06/01/26.
//
import SwiftUI
import Combine

// MARK: - ViewModel
class CommentViewModel: ObservableObject {
    @Published var CommentsArray: [CommentsData] = []
    
    var totalCommentCount: Int {
            CommentsArray.count
        }
    @Published var showActivity = false
    @Published var showError = false
    @Published var errorMessage: String?
    
    @Published var page: Int = 1
    @Published var limit: Int = 20
    @Published var totalPages: Int = 1
    @Published var isPaginating: Bool = false
    
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - API
    func getCommentApi(postId: String, isLoadMore: Bool = false) {
        guard !isPaginating else { return }
        
        isPaginating = true
        showActivity = page == 1
        
        APIManager.shared.getCommentApi(postID: postId, page: page, limit: limit)
            .sink { completion in
                self.showActivity = false
                self.isPaginating = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                guard response.success ?? false else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    return
                }
                let newItems = response.data?.data ?? []
                self.totalPages = response.data?.totalPage ?? 1
                if isLoadMore {
                    self.CommentsArray.append(contentsOf: newItems)
                } else {
                    self.CommentsArray = newItems
                }
            }
            .store(in: &cancellables)
    }
    
    func loadMoreIfNeeded(postID: String, currentIndex: Int) {
        guard currentIndex == CommentsArray.count - 1 else { return }
        guard page < totalPages else { return }
        page += 1
        getCommentApi(postId: postID, isLoadMore: true)
    }
    
    // MARK: - Add Comment / Reply
    func addCommentApi(postId: String, text: String) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        APIManager.shared.addCommentApi(postid: postId, commenttxt: text)
            .sink { _ in } receiveValue: { _ in
                self.getCommentApi(postId: postId)
            }
            .store(in: &cancellables)
    }
    
 
    // MARK: - Edit Comment
    func editCommentApi(
        commentid: String,
        text: String,
        postId: String,
        onSuccess: @escaping () -> Void
    ) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        showActivity = true
        APIManager.shared.editCommentApi(commentid: commentid, commenttxt: text)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                guard response.success ?? false else { return }

                // Refresh comments
                self.getCommentApi(postId: postId)

                // 🔹 Notify View that editing succeeded
                onSuccess()
            }
            .store(in: &cancellables)
    }

    
    
    // MARK: - Like / Unlike
    func toggleLikeComment(comment: CommentsData) {
        guard let id = comment.id else { return }
        showActivity = true
        APIManager.shared.likeUnlikeCommentApi(commentId: "\(id)")
            .sink { _ in } receiveValue: { _ in
                self.showActivity = false
                if let index = self.CommentsArray.firstIndex(where: { $0.id == id }) {
                    let currentLike = self.CommentsArray[index].isLikedByCurrentUser ?? false
                    self.CommentsArray[index].isLikedByCurrentUser = !currentLike
                    if let count = self.CommentsArray[index].likeCount {
                        self.CommentsArray[index].likeCount = currentLike ? count - 1 : count + 1
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func addReplyApi(parentCommentId: Int, text: String, postID: String) {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        showActivity = true
        APIManager.shared.addReplyCommentApi(commentTxt: text, commentId: "\(parentCommentId)", postID: postID)
            .sink { completion in
                self.showActivity = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                guard response.success ?? false else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    return
                }
                
                self.getCommentApi(postId: postID)

            }
            .store(in: &cancellables)
    }

    
    // MARK: - Delete Comment
    func deleteComment(comment: CommentsData) {
        
        guard let id = comment.id else { return }
        showActivity = true
        APIManager.shared.deleteCommentApi(commentId: "\(id)")
            .sink { completion in
                self.showActivity = false
                if case let .failure(error) = completion {
                    print("❌ Delete comment failed:", error.localizedDescription)
                }
            } receiveValue: { _ in
                
                // 1️⃣ Remove main comment
                if let index = self.CommentsArray.firstIndex(where: { $0.id == id }) {
                    self.CommentsArray.remove(at: index)
                    return
                }
                
                // 2️⃣ Remove reply (nested comment)
                for i in self.CommentsArray.indices {
                    if let replyIndex = self.CommentsArray[i].replies.firstIndex(where: { $0.id == id }) {
                        self.CommentsArray[i].replies.remove(at: replyIndex)
                        return
                    }
                }
            }
            .store(in: &cancellables)
    }

    
    func toggleLikeReply(commentId: Int, reply: CommentReply) {
        guard let replyId = reply.id else { return }
        showActivity = true
        APIManager.shared.likeUnlikeCommentApi(commentId: "\(replyId)")
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { _ in
                self.showActivity = false
                guard let cIndex = self.CommentsArray.firstIndex(where: { $0.id == commentId }),
                      let rIndex = self.CommentsArray[cIndex].replies.firstIndex(where: { $0.id == replyId })
                else { return }
                
                let isLiked = self.CommentsArray[cIndex].replies[rIndex].isLikedByCurrentUser ?? false
                
                self.CommentsArray[cIndex].replies[rIndex].isLikedByCurrentUser = !isLiked
                self.CommentsArray[cIndex].replies[rIndex].likeCount =
                (self.CommentsArray[cIndex].replies[rIndex].likeCount ?? 0)
                + (isLiked ? -1 : 1)
            }
            .store(in: &cancellables)
    }
}
