//
//  FeedView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct HomeView: View {
 
    @StateObject private var viewModel = HomeViewModel()
    @State private var showComments = false
    @State private var showShare = false
    @EnvironmentObject private var tabRouter: TabRouter
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showToast: Bool = false
    @State private var showReportPostPopUp = false
    @State private var activeMenuIndex: Int? = nil
    @State private var selectedPostID: String = ""
    
        var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("logoimage")
                        .frame(width: 100, height: 30)
                    
                    Spacer()
                    
                    Button {
                        coordinator.push(.notificationView)
                    } label: {
                        Image("NotificationIcon")
                    }
                    
                    Button {
                        coordinator.push(.chatListView)
                    } label: {
                        Image("ChatIcon")
                    }
                    .frame(width: 40, height: 40)
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                //.padding(.horizontal, 15)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                   
                if viewModel.feedItems.isEmpty{
                    Spacer()
                    NoDataFoundView()
                    Spacer()
                }else{
                    // Feed
                    ScrollView {
                        Spacer().frame(height: 10)
                        
                        LazyVStack(spacing: 16) {
                            
                            ForEach(Array(viewModel.feedItems.enumerated()), id: \.offset) { index, item in
                                viewForItem(item, index: index)
                                    .onAppear {
                                        //  Pagination Trigger
                                        viewModel.loadMoreIfNeeded(currentIndex: index)
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
                        viewModel.showReportPopUp = true
                    },   onCommentsUpdated: { newCount in
                        viewModel.updateCommentCount(
                            postId: selectedPostID,
                            count: newCount
                        )
                    }
                )
            }
            
            // Report Popup
            if viewModel.showReportPopUp {
                ReportCommentPopup(
                    reportOn: viewModel.reportFor ?? "",
                    onCancel: {
                        viewModel.showReportPopUp = false
                        tabRouter.isTabBarHidden = false
                    },
                    onSubmit: {
                        viewModel.showReportPopUp = false
                        tabRouter.isTabBarHidden = false
                        self.showToast = true
                    }
                )
            }
            
            // Toast
            if self.showToast {
                ToastView {
                    self.showToast = false
                }
            }
            if showReportPostPopUp{
                ReportPostPopUp(
                    reportOn: "Post",
                    onCancel: {
                        showReportPostPopUp = false
                        tabRouter.isTabBarHidden = false
                    },
                    onSubmit: {
                        showReportPostPopUp = false
                        tabRouter.isTabBarHidden = false
                        showToast = true
                    }
                )
            }
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .onAppear() {
            viewModel.page = 1
            viewModel.limit = 20
            viewModel.homeDataApi()
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
                    viewModel.showReportPopUp = true
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
                },
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
                    viewModel.showReportPopUp = true
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
                    selectedPostID = item.postID ?? ""
                    showComments = true
                    tabRouter.isTabBarHidden = true
                },
                onReportTap: {
                    showShare = true
                    tabRouter.isTabBarHidden = true
                },
                onShareTap: {
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onReportPostTap: {
                    showReportPostPopUp = true
                    tabRouter.isTabBarHidden = true
                },
                onFollowTap: {
                    viewModel.FollowUnfollowApi(index: item.userID ?? "", Index1: index)
                    },
                onLikeTap: { isLiked in
                    viewModel.likeUnlikeApi(postId: item.postID ?? "", index: index, postType: "Post", comingFrom: "")
                },
                onSaveTap: {
                    viewModel.SaveUnsaveApi(postId: item.postID ?? "", Index1: index, postType: "Post", comingFrom: "")
                    }
            )


//        case .video(let video):
//            VideoCard(
//                video: video,
//                onCommentTap: {
//                    showComments = true
//                    tabRouter.isTabBarHidden = true
//                }, isMenuVisible: Binding(
//                    get: { activeMenuIndex == index },
//                    set: { isVisible in activeMenuIndex = isVisible ? index : nil }
//                ),
//                onReportTap: {
//                    viewModel.showReportPopUp = true
//                    tabRouter.isTabBarHidden = true
//                },
//                onShareTap: {
//                    showShare = true
//                    tabRouter.isTabBarHidden = true
//                },
//                onReportPostTap: {
//                    showReportPostPopUp = true
//                    tabRouter.isTabBarHidden = true
//                }
//            )
        case .none:
            EmptyView()   // 👈 handles nil safely
        }
    }

}


#Preview {
    HomeView()
        .environmentObject(TabRouter())
        .environmentObject(Coordinator())
}
