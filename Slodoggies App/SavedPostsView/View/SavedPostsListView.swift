//
//  SavedPostsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import SwiftUI

struct SavedPostsView: View {
    var userID = ""
    var comingFrom : String = ""
    @StateObject private var viewModel = HomeViewModel()
    @State private var showComments = false
    @State private var showShare = false
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showToast: Bool = false
    @State private var showReportPostPopUp = false
    @State private var activeMenuIndex: Int? = nil
    @State private var selectedPostID: String = ""
    @State private var showEventSavedPopup = false
    @State private var showDeletePopUp = false
    @State private var showEditPost = false
    
    @State private var toastMessage = ""
    
   @State private var toastSuccess = false
    
    var onSelect: (() -> Void)? = nil
    
    @State private var postID: String = ""
    @State private var indexneedtodelete: Int = 0
    
    // Editpost
    @State private var selectedPostIndex: Int? = nil
    @State private var selectedPost: MyPostItem? = nil
    
    var body: some View {
        ZStack {
         
            VStack {
                HStack(spacing: 20){
                    Button(action: {
                        onSelect?()
                        coordinator.pop()
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("Posts")
                        .font(.custom("Outfit-Medium", size: 22))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                    Spacer()
                }
                .padding(.leading)
                .padding(.bottom, 10)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                // Feed
                ScrollView {
                    Spacer().frame(height: 10)
                    
                    LazyVStack(spacing: 16) {
                        if comingFrom == "Saved" {
                            ForEach(Array(viewModel.feedItems.enumerated()), id: \.offset) { index, item in
                                viewForItem(item, index: index)
                                    .onAppear {
                                        viewModel.loadMoreIfNeededMySavedPost(currentIndex: index)
                                    }
                            }
                        }
                        
                        if comingFrom == "MyProfile" || comingFrom == "OtherProfile"{
                            ForEach(Array(viewModel.MyPostItem.enumerated()), id: \.offset) { index, item in
                                viewForItemMyPost(item, index: index)
                                    .contentShape(Rectangle()) // 👈 important
                                    .onAppear {
                                        viewModel.loadMoreIfNeededMyPost(userId: userID, currentIndex: index)
                                    }
                            }
                        }
                        
                        //  Bottom Pagination Loader
                        if viewModel.isPaginating && viewModel.page > 1 {
                            ProgressView()
                                .padding(.vertical, 20)
                        }
                    }
                    .padding(.bottom, 40) // for safe area / tab bar
                }
                .refreshable {
                    //                    viewModel.page = 1
                    //                    viewModel.limit = 20
                    //                    viewModel.homeDataApi()
                }
                .background(Color(hex: "#E5EFF2"))
                .padding(.top, -8)
                
                
            }
            
            // Comments Popup
            if showShare {
                
                CustomShareSheetView(
                   
                    isPresented: .constant(true), onCancel: {
                        showShare = false
                        tabRouter.isTabBarHidden = false
                    }
                )
            }
            
            if showComments {
                CommentsPopupView(
                    postId: selectedPostID,
                    onCancel: {
                        showComments = false
                        tabRouter.isTabBarHidden = false
                    },
                    onReportTapped: {
                        showComments = false
                        viewModel.showPostReportPopUp = true
                    },   onCommentsUpdated: { newCount in
                        viewModel.updateCommentCount(
                            postId: selectedPostID,
                            count: newCount
                        )
                    }
                )
            }
            
            // Report Popup
            if viewModel.showPostReportPopUp {
                ReportCommentPopup(
                    reportOn: viewModel.reportFor ?? "",
                    onCancel: {
                        viewModel.showPostReportPopUp = false
                        tabRouter.isTabBarHidden = false
                    },
                    onSubmit: {
                        viewModel.showPostReportPopUp = false
                        tabRouter.isTabBarHidden = false
                        self.showToast = true
                    }
                )
            }
            
            // Toast
            if showToast {
                ToastView(
                    message: toastMessage,
                    isSuccess: toastSuccess,
                    onCancel: {
                        showToast = false
                    }
                )
            }
//
            if showReportPostPopUp {
                ReportPostPopUp(
                    reportOn: "Post",
                    onCancel: {
                        showReportPostPopUp = false
                        tabRouter.isTabBarHidden = false
                    },
                    onSubmit: {reason,message in
                        showReportPostPopUp = false
                        tabRouter.isTabBarHidden = false
                        showToast = true
                    }
                )
            }
            
            if showEditPost,
               let index = selectedPostIndex,
               let post = selectedPost {

                EditPostView(
                    isPresented: $showEditPost,
                    post: post,
                    onSave: { newText in
                        tabRouter.isTabBarHidden = false
                        viewModel.editPostApi(postId: postID, text: newText)

                    }
                )
                .transition(.move(edge: .bottom))
            }
            
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }

            if showToast {
                ToastView(
                    message: toastMessage,
                    isSuccess: toastSuccess,
                    onCancel: {
                        showToast = false
                    }
                )
            }
            
            if showDeletePopUp {
                DeleteSavedPostsPopUpView(
                    isVisible: $showDeletePopUp
                ) { action in
                    tabRouter.isTabBarHidden = false
                    
                    if action == "Yes" {
                        viewModel.deletePostApi(
                            postId: "\(postID)",
                            index: indexneedtodelete,
                            comingFrom: "myPost"
                        )
                    } else {
                        print("User cancelled delete")
                    }
                }

                .ignoresSafeArea()   // forces full-screen coverage
                .transition(.opacity)
            }
        }
        .onTapGesture {
            // Close menu when tapping outside
              if activeMenuIndex != nil {
                  activeMenuIndex = nil
              }
        }
        .onAppear {
            print(comingFrom, "ComingFrom")
            
            if viewModel.feedItems.isEmpty {
                viewModel.page = 1
                viewModel.limit = 20
                
                if comingFrom == "Saved" {
                    viewModel.getMySavedPostApi()
                }
                
                if comingFrom == "MyProfile" || comingFrom == "OtherProfile"{
                    viewModel.getMyPostApi(UserID: userID)
                }
            }
        }
    }
    
    // MARK: - Helper
    @ViewBuilder
    private func viewForItem(_ item: HomeItem, index: Int) -> some View {
        
        switch item.type {
        case .community:
            EventCard(
                item: item,
                isMenuVisible: Binding(
                    get: { activeMenuIndex == index },
                    set: { activeMenuIndex = $0 ? index : nil }
                ),
                onCommentTap: {
                    selectedPostID = item.postID ?? ""
                    showComments = true
                    tabRouter.isTabBarHidden = true
                },
                onReportTap: {
                    viewModel.showPostReportPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onShareTap: {
                    showShare = true
                    tabRouter.isTabBarHidden = true
                },
                onReportPostTap: {
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onProfileTap: {
                    if item.author?.authorType == .owner {
                        coordinator.push(.profileDetailsView(item.author?.userID ?? "",""))
                    }else{
                        coordinator.push(.busiProfileView("Home", item.author?.userID ?? "", hideSponsoredButton: true))
                    }
                    
                },
                onJoinCommunityTap: {
                    coordinator.push(.groupChatView)
                }, showSavedPopup: $showEventSavedPopup,
                onFollowTap: {
                    viewModel.FollowUnfollowApi(index: item.userID ?? "", Index1: index)
                },
                onLikeTap: { isLiked in
                    viewModel.likeUnlikeApi(postId: item.postID ?? "", index: index, postType: "Event", comingFrom: "")
                },
                onSaveTap: {
                    viewModel.SaveUnsaveApi(postId: item.postID ?? "", Index1: index, postType: "Event", comingFrom: "")
                }
            )
        case .sponsored:
            AdCard (
                ad: item,
                onCommentTap: {
                    selectedPostID = item.postID ?? ""
                    showComments = true
                    tabRouter.isTabBarHidden = true
                }, isMenuVisible: Binding(
                    get: { activeMenuIndex == index },
                    set: { isVisible in activeMenuIndex = isVisible ? index : nil }
                ),
                onReportTap: {
                    viewModel.showPostReportPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onShareTap: {
                    showShare = true
                    tabRouter.isTabBarHidden = true
                },
                onReportPostTap: {
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onLikeTap: { isLiked in
                    viewModel.likeUnlikeApi(postId: item.postID ?? "", index: index, postType: "Sponsor", comingFrom: "")
                }
            )
            
        case .normal:
            PetPostCardView(
                item: item,
                isMenuVisible: Binding(
                    get: { activeMenuIndex == index },
                    set: { activeMenuIndex = $0 ? index : nil }
                ),
                onCommentTap: {
                    activeMenuIndex = nil
                    selectedPostID = item.postID ?? ""
                    showComments = true
                    tabRouter.isTabBarHidden = true
                },
                onReportTap: {
                    activeMenuIndex = nil
                    showShare = true
                    tabRouter.isTabBarHidden = true
                },
                onShareTap: {
                    activeMenuIndex = nil
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onReportPostTap: {
                    activeMenuIndex = nil
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                }, showSavedPopup: $showEventSavedPopup,
                onFollowTap: {
                    activeMenuIndex = nil
                    viewModel.FollowUnfollowApi(index: item.userID ?? "", Index1: index)
                },
                onLikeTap: { isLiked in
                    activeMenuIndex = nil
                    viewModel.likeUnlikeApi(postId: item.postID ?? "", index: index, postType: "Post", comingFrom: "")
                },
                onSaveTap: {
                    activeMenuIndex = nil
                    viewModel.SaveUnsaveApi(postId: item.postID ?? "", Index1: index, postType: "Post", comingFrom: "")
                }
            )
        case .none:
            EmptyView()   // handles nil safely
        }
    }
    
    // MARK: - Helper
    @ViewBuilder
    private func viewForItemMyPost(_ item: MyPostItem, index: Int) -> some View {
        
        MyPostCardView(
            item: item,
            index: index,   isMenuVisible: Binding(
                get: { activeMenuIndex == index },
                set: { activeMenuIndex = $0 ? index : nil }
            ),
            onCommentTap: {
                activeMenuIndex = nil
                selectedPostID = "\(item.id ?? 0)"
                showComments = true
                tabRouter.isTabBarHidden = true
            },
            onReportTap: {
                activeMenuIndex = nil
                showShare = true
                tabRouter.isTabBarHidden = true
            },
            onShareTap: {
                activeMenuIndex = nil
                showReportPostPopUp = true
                tabRouter.isTabBarHidden = true
            },
            onReportPostTap: {
                activeMenuIndex = nil
                showReportPostPopUp = true
                tabRouter.isTabBarHidden = true
            },
            onFollowTap: {
                activeMenuIndex = nil
                viewModel.FollowUnfollowApi(index: "\(item.userID ?? 0)", Index1: index)
            },
            onSaveTap: {
                activeMenuIndex = nil
                viewModel.SaveUnsaveApi(postId: "\(item.id ?? 0)", Index1: index, postType: "Post", comingFrom: "myPost")
            },
            onEditTap: {
                print("Edit tapped")
                selectedPostIndex = index
                selectedPost = item
                activeMenuIndex = nil
                postID = "\(item.id ?? 0)"
                DispatchQueue.main.async {
                    showEditPost = true
                }
            },

            onDeleteTap: {
                activeMenuIndex = nil
                // Store selected post details
                postID = "\(item.id ?? 0)"
                indexneedtodelete = index
                showDeletePopUp = true
            },
            onLikeTap: { (isLiked: Bool) in
                activeMenuIndex = nil
                viewModel.likeUnlikeApi(
                    postId: "\(item.id ?? 0)",
                    index: index,
                    postType: "Post", comingFrom: "myPost"
                )
            }
        )
    }
    
}

#Preview {
    SavedPostsView()
        .environmentObject(TabRouter())
        .environmentObject(Coordinator())
}





