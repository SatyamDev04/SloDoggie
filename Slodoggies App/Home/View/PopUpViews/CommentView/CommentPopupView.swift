//
//  CommentPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentsPopupView: View {
    var postId: String
    @StateObject var viewModel = CommentViewModel()
    @State private var inputText: String = ""
    var onCancel: (() -> Void)
    var onReportTapped: (() -> Void)
    
    var onCommentsUpdated: (Int) -> Void   // 👈 NEW
    
    @State private var replyUserName = ""
    @State private var replyUserImage = ""

    @State private var inputMode: InputMode = .newComment

    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // Close Button
                HStack {
                    Spacer()
                    Button(action: {
                        onCancel()
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .padding(.trailing, 25)
                            .padding(.top, 20)
                    }
                }
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Comments")
                            .font(.custom("Outfit-Medium", size: 20))
                        Spacer()
                    }
                    .padding()
                    
                    Divider()
                        .frame(height: 2)
                        .background(Color(hex: "#258694"))
                    
                    Spacer()
                    
                    // Comments List
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 12) {

                            ForEach($viewModel.CommentsArray) { $comment in
                                CommentRowView(
                                    comment: $comment,   // ✅ binding
                                    viewModel: viewModel,
                                    inputText: $inputText,
                                    level: 0,
                                    currentUserId: Int(UserDetail.shared.getUserId()) ?? 0,
                                    onReportTapped: onReportTapped,
                                    onEditTapped: handleEdit,
                                    onReplyTapped: { parentComment in
                                        handleReply(parentComment)
                                    }
                                )
                            }

                        }
                        .padding(.horizontal)
                    }
                    
                    // Input Area
                    VStack(spacing: 0) {

                        // Reply / Edit Indicator
                        if isReplyOrEditMode {
                            HStack {
                                Text(indicatorText)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(Color(hex: "#00637A"))

                                Spacer()

                                Button {
                                    cancelEdit()
                                } label: {
                                    Image("cancelBtnIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                }
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#00637A").opacity(0.10))

                            Divider()
                                .frame(height: 1)
                                .background(Color(hex: "#258694"))
                        }

                        // Input Field + Send Button
                        HStack(spacing: 12) {
                            Button {
                                // emoji action
                            } label: {
                                Image("emojy")
                                    .resizable()
                                    .frame(width: 32, height: 32)
                            }

                            ZStack(alignment: .leading) {
                                if inputText.isEmpty {
                                    Text("Type your comment here")
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }

                                TextField("", text: $inputText)
                                    .font(.system(size: 15))
                                    .foregroundColor(.black)
                                    .disableAutocorrection(true)
                            }

                            Button(action: {
                                sendComment()
                            }) {
                                Image("sendmsg")
                                    .resizable()
                                    .frame(width: 33, height: 33)
                            }
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(hex: "#00637A").opacity(0.10))
                    }
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                    
                }
                .background(Color.white)
                .cornerRadius(16)
                .frame(maxHeight: UIScreen.main.bounds.height * 0.7)
                .padding()
            }
            
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.getCommentApi(postId: postId)
        }
        
        .onDisappear {
                    // Send latest comment count back
                    onCommentsUpdated(viewModel.totalCommentCount)
                }
        
        
    }
   // Handle edit comment
    private func handleEdit(_ comment: CommentsData) {
        inputMode = .edit(commentId: "\(comment.id ?? 0)")
        replyUserName = comment.user?.name ?? ""
        inputText = comment.content ?? ""
    }
   // Reply to comment
    private func handleReply(_ comment: CommentsData) {
        inputMode = .reply(
            parentCommentId: comment.id ?? 0,
            replyToUser: comment.user?.name ?? ""
        )
        replyUserName = comment.user?.name ?? ""
        inputText = ""
    }
// Reply to nested reply
    private func handleReply(_ reply: CommentReply, parentCommentId: Int) {
        inputMode = .reply(
            parentCommentId: parentCommentId,
            replyToUser: reply.user?.name ?? ""
        )
        replyUserName = reply.user?.name ?? ""
        inputText = ""
    }

    private func sendComment() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        switch inputMode {

        case .newComment:
            viewModel.addCommentApi(postId: postId, text: inputText)
            resetInput()

        case .edit(let commentId):
            viewModel.editCommentApi(
                commentid: commentId,
                text: inputText,
                postId: postId
            ) {
                resetInput() // ✅ only after success
            }

        case .reply(let parentCommentId, _):
            viewModel.addReplyApi(
                parentCommentId: parentCommentId,
                text: inputText,
                postID: postId
            )
            resetInput()
        }
    }


    private func cancelEdit() {
        resetInput()
    }
    
    private func resetInput() {
        inputText = ""
        inputMode = .newComment
        replyUserName = ""
        replyUserImage = ""
    }
    private var indicatorText: String {
        switch inputMode {
        case .reply(_, let name):
            return "Replying to \(name)"
        case .edit:
            return "Editing comment"
        case .newComment:
            return ""
        }
    }

    private var isReplyOrEditMode: Bool {
        switch inputMode {
        case .newComment:
            return false
        case .edit, .reply:
            return true
        }
    }


}



import SwiftUI
import SDWebImageSwiftUI

struct CommentRowView: View {

    @Binding var comment: CommentsData
      @ObservedObject var viewModel: CommentViewModel
      @Binding var inputText: String
      let level: Int
      let currentUserId: Int
      let onReportTapped: () -> Void
      let onEditTapped: (CommentsData) -> Void
      let onReplyTapped: (CommentsData) -> Void

    var isMyComment: Bool {
        comment.user?.id == currentUserId
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(comment.user?.image ?? "NoUserFound")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading, CGFloat(level) * 20)

            VStack(alignment: .leading, spacing: 6) {

                // NAME + TIME + ACTIONS
                HStack(alignment: .top) {

                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 6) {
                            Text(comment.user?.name ?? "")
                                .font(.custom("Outfit-Medium", size: 14))

                            Text(comment.createdAt ?? "")
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(.gray)
                        }

                        Text("Pet Mom")
                            .font(.custom("Outfit-Regular", size: 10))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color(hex: "#EAF4F6"))
                            .foregroundColor(Color(hex: "#258694"))
                            .cornerRadius(10)
                    }

                    Spacer()

                    if isMyComment {
                        HStack(spacing: 12) {
                            Button {
                                onEditTapped(comment)
                            } label: {
                                Image("PencilIcon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }

                            Button {
                                viewModel.deleteComment(comment: comment)
                            } label: {
                                Image("deleteIcon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                            }
                        }
                    } else {
                        Menu {
                            Button {
                                onReportTapped()
                            } label: {
                                HStack(spacing: 0) {
                                    Image(systemName: "exclamationmark.circle")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                    Text("Report Comment")
                                        .font(.custom("Outfit-Medium", size: 14))
                                        .foregroundColor(.black)
                                }
                            }
                        } label: {
                            Image("ThreeDots")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        }
                    }
                }

                // COMMENT TEXT + LIKE
                HStack(alignment: .top) {
                    Text(comment.content ?? "")
                        .font(.custom("Outfit-Regular", size: 14))
                    Spacer()
                    Button {
                        viewModel.toggleLikeComment(comment: comment)
                    } label: {
                        HStack(spacing: 4) {
                            Image(comment.isLikedByCurrentUser ?? false ? "PawLiked" : "PawUnliked")
                                .resizable()
                                .frame(width: 14, height: 14)
                            if let count = comment.likeCount, count > 0 {
                                Text("\(count)")
                                    .font(.custom("Outfit-Regular", size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }

                // 🔹 Reply Button
                Button("Reply") {
                    onReplyTapped(comment)
                }
                .font(.custom("Outfit-Regular", size: 13))
                .foregroundColor(Color(hex: "#258694"))

                // NESTED REPLIES
                ForEach($comment.replies) { $reply in
                    ReplyRowView(
                        commentId: comment.id ?? 0,
                        reply: $reply,
                        viewModel: viewModel,
                        inputText: $inputText,
                        level: level + 1,
                        onReplyTapped: { reply in
                            onReplyTapped(comment)
                        }
                    )
                }

            }
        }
        .padding(.vertical, 10)
    }
}

import SwiftUI

struct ReplyRowView: View {
    let commentId: Int
    @Binding var reply: CommentReply
    @ObservedObject var viewModel: CommentViewModel
    @Binding var inputText: String
    let level: Int
    let onReplyTapped: (CommentReply) -> Void   // 🔹 Added

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(reply.user?.image ?? "NoUserFound")
                .resizable()
                .frame(width: 34, height: 34)
                .clipShape(Circle())
                .padding(.leading, CGFloat(level) * 20)

            VStack(alignment: .leading, spacing: 6) {

                HStack {
                    Text(reply.user?.name ?? "")
                        .font(.custom("Outfit-Medium", size: 13))

                    Text(reply.createdAt ?? "")
                        .font(.custom("Outfit-Regular", size: 11))
                        .foregroundColor(.gray)

                    Spacer()
                }

                Text(reply.content ?? "")
                    .font(.custom("Outfit-Regular", size: 13))

                HStack {
                    Button("Reply") {
                        onReplyTapped(reply)
                    }
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color(hex: "#258694"))

                    Spacer()

                    Button {
                        viewModel.toggleLikeReply(commentId: commentId, reply: reply)
                    } label: {
                        HStack(spacing: 4) {
                            Image(reply.isLikedByCurrentUser ?? false ? "PawLiked" : "PawUnliked")
                                .resizable()
                                .frame(width: 12, height: 12)
                            if let count = reply.likeCount, count > 0 {
                                Text("\(count)")
                                    .font(.custom("Outfit-Regular", size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 6)
    }
}



// MARK: - Preview
struct CommentsPopupView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsPopupView(postId: "", onCancel: {}, onReportTapped: {}, onCommentsUpdated: { _ in })
            .previewLayout(.sizeThatFits)
    }
}
