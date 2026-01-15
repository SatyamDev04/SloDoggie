//
//  DiscoverView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct DiscoverView: View {
    
    // MARK: - ViewModel
    @StateObject private var viewModel = DiscoverViewModel()
    
    // MARK: - Environment
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var tabRouter: TabRouter
    
    // MARK: - Local States
    @State private var selectedPlace: PetPlace?
    @State private var showPopup = false
    @State private var showComments = false
    @State private var showEventSavedPopup = false
    @State private var showShare = false
    @State private var showReportPostPopUp = false
    @State private var activeMenuIndex: Int? = nil
    
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                searchBar
                hashtagsSection
                categoriesSection
                contentView()
            }
            .padding(.top)
            
            // Global Loader
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
                    .zIndex(999)
            }
            
            // ===== POPUPS =====
            
            if showEventSavedPopup {
                EventSavedSuccessPopUp(isVisible: $showEventSavedPopup)
                    .zIndex(2)
            }
            
            if showPopup, let place = selectedPlace {
                PetPlacesPopUpView(
                    place: place,
                    onCancel: closePopup,
                    onSubmit: closePopup
                )
                .onAppear { tabRouter.isTabBarHidden = true }
                .zIndex(3)
            }
            
            if showComments && !viewModel.showReportPopup {
                CommentsPopupView(
                    postId: "", onCancel: {
                        showComments = false
                        tabRouter.isTabBarHidden = false
                    },
                    onReportTapped: {
                        showComments = false
                        viewModel.showReportPopup = true
                    },
                    onCommentsUpdated: {_ in}
                )
                .zIndex(4)
            }
            
            if viewModel.showReportPopup && !showComments {
                ReportCommentPopup(
                    reportOn: "",
                    onCancel: closeReportPopup,
                    onSubmit: closeReportPopup
                )
                .zIndex(5)
            }
            
            if showShare {
                CustomShareSheetView(
                    isPresented: $showShare,
                    onCancel: {
                        showShare = false
                        tabRouter.isTabBarHidden = false
                    }
                )
                .zIndex(6)
            }
            
            if showReportPostPopUp {
                ReportPostPopUp(
                    reportOn: "Post",
                    onCancel: closePostReportPopup,
                    onSubmit: closePostReportPopup
                )
                .zIndex(7)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

// MARK: - Components
private extension DiscoverView {
    
    // MARK: - Search Bar
    var searchBar: some View {
        HStack {
            Image("Search")
            TextField("Search", text: $viewModel.query)
                .textFieldStyle(.plain)
        }
        .padding()
        .frame(height: 42)
        .background(Color(hex: "#F4F4F4"))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    // MARK: - Hashtags
    var hashtagsSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(viewModel.trendingHashtags.indices, id: \.self) { index in
                    let item = viewModel.trendingHashtags[index]
                    
                    Text(item.hashtag ?? "")
                        .font(.custom("Outfit-Regular", size: 11))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .foregroundColor(Color(hex: "#258694"))
                        .background(Color(red: 229/255, green: 239/255, blue: 242/255))
                        .cornerRadius(5)
                }
            }
            .padding(.horizontal)
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    // MARK: - Categories
    var categoriesSection: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories, id: \.self) { category in
                    Button {
                        viewModel.selectCategory(category)
                    } label: {
                        Text(category)
                            .font(.custom("Outfit-Regular", size: 14))
                            .padding(.horizontal, 16)
                            .frame(height: 42)
                            .background(
                                viewModel.selectedCategory == category
                                ? Color(hex: "#258694")
                                : Color.white
                            )
                            .foregroundColor(
                                viewModel.selectedCategory == category
                                ? .white
                                : Color(hex: "#949494")
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(hex: "#949494"), lineWidth: 1)
                            )
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
        }
        .scrollDismissesKeyboard(.interactively)
    }
    
    // MARK: - Content View
    @ViewBuilder
    func contentView() -> some View {
        ScrollView {
            switch viewModel.selectedCategory {
            case "Events":
                eventsSection
            case "Pet Places":
                petPlacesSection
            case "Activities":
                activitiesSection
            default:
                usersSection
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .padding(.bottom, 30)
    }
    
    // MARK: - Events
    var eventsSection: some View {
        VStack(spacing: 20) {
            
            if viewModel.events.isEmpty{
                HStack{
                    Spacer()
                    NoDataFoundView()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 300)
                    Spacer()
                }
            }else{
                ForEach(viewModel.events, id: \.postId) { event in
                    // derive index when needed
                    let index = viewModel.events.firstIndex(where: { $0.postId == event.postId }) ?? 0
                    
                    DiscoverEventCard(
                        event: event,
                        showSavedPopup: $showEventSavedPopup,
                        isMenuVisible: Binding(
                            get: { activeMenuIndex == index },
                            set: { activeMenuIndex = $0 ? index : nil }
                        ),
                        onReportTap: { viewModel.showReportPopup = true },
                        onCommentTap: {
                            showComments = true
                            tabRouter.isTabBarHidden = true
                        },
                        onShareTap: {
                            showShare = true
                            tabRouter.isTabBarHidden = true
                        },
                        onLikeTap: { isLiked in
                            viewModel.likeUnlikeApi(
                                postId: String(event.postId),
                                index: index,
                                postType: "Event"
                            )
                        },
                        onReportPostTap: {
                            showReportPostPopUp = true
                            tabRouter.isTabBarHidden = true
                        },onJoinCommunityTap: {
                            coordinator.push(.groupChatView)
                        }
                    )
                    .onAppear {
                        // pagination trigger on last item
                        if event.postId == viewModel.events.last?.postId {
                            viewModel.fetchEvents(
                                page: viewModel.eventsPage + 1,
                                search: viewModel.query
                            )
                        }
                    }
                }
            }
            // Optional loader at bottom
            if viewModel.isEventsLoadingMore {
                ProgressView()
                    .padding()
            }
            
        }
    }
    
    // MARK: - Pet Places
    var petPlacesSection: some View {
        VStack(){
            if viewModel.petPlaces.isEmpty{
                HStack{
                    Spacer()
                    NoDataFoundView()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 300)
                    Spacer()
                }
                
            }else{
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 14
                ) {
                    
                    ForEach(viewModel.petPlaces) { place in
                        PetPlaceCard(place: place)
                            .onAppear {
                                if place.id == viewModel.petPlaces.last?.id,
                                   viewModel.petPlacesPage < viewModel.petPlacesTotalPages,
                                   !viewModel.petPlacesLoadingMore {
                                    viewModel.fetchPetPlaces(
                                        search: viewModel.query,
                                        page: viewModel.petPlacesPage + 1
                                    )
                                }
                            }
                            .onTapGesture {
                                selectedPlace = place
                                showPopup = true
                            }
                    }
                }
                // Bottom loader while fetching next page
                if viewModel.petPlacesLoadingMore {
                    ProgressView()
                        .padding(.vertical, 12)
                }
            }
        }
    }
    
    // MARK: - Activities
    var activitiesSection: some View {
        VStack(spacing: 20) {
            if viewModel.activities.isEmpty{
                HStack{
                    Spacer()
                    NoDataFoundView()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 300)
                    Spacer()
                }
            }else{
                ForEach(viewModel.activities) { activity in
                    let index = viewModel.activities.firstIndex(where: { $0.id == activity.id }) ?? 0
                    
                    ActivitiesCardView(
                        activity: activity,
                        isMenuVisible: Binding(
                            get: { activeMenuIndex == index },
                            set: { activeMenuIndex = $0 ? index : nil }
                        ),
                        onCommentTap: {
                            showComments = true
                            tabRouter.isTabBarHidden = true
                        },
                        onReportTap: {
                            viewModel.showReportPopup = true
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
                        onLikeTap: { _ in
                            viewModel.likeUnlikeApi(
                                postId: activity.postId ?? "",
                                index: index,
                                postType: "Post"
                            )
                        }
                    )
                    .onAppear {
                        if index == viewModel.activities.count - 1 {
                            viewModel.fetchActivities(
                                page: viewModel.activitiesPage + 1,
                                search: viewModel.query
                            )
                        }
                    }
                }
            }
            // Optional loader at bottom
            if viewModel.isActivitiesLoadingMore {
                ProgressView()
                    .padding()
            }
        }
    }
    
    // MARK: - Pets Near You
    var usersSection: some View {
        VStack(spacing: 12) {
            if viewModel.petsNearYou.isEmpty{
                HStack{
                    Spacer()
                    NoDataFoundView()
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 300)
                    Spacer()
                }
                
            }else{
                ForEach(viewModel.petsNearYou.indices, id: \.self) { index in
                    let pet = viewModel.petsNearYou[index]
                    
                    HStack {
                        if let image = pet.image,
                           let url = URL(string: image),
                           !image.isEmpty {
                            WebImage(url: url)
                                .resizable()
                                .indicator(.activity)
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } else {
                            Image("download")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pet.name)
                                .font(.custom("Outfit-Regular", size: 14))
                            
                            if let distance = pet.distance {
                                Text(distance)
                                    .font(.custom("Outfit-Regular", size: 10))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .foregroundColor(Color(hex: "#258694"))
                                    .background(Color(red: 229/255, green: 239/255, blue: 242/255))
                                    .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .onTapGesture {
                        coordinator.push(.profileDetailsView(pet.pet_owner_id,pet.name))
                    }
                    .onAppear {
                        if index == viewModel.petsNearYou.count - 1 {
                            viewModel.fetchPetNearYou(
                                page: viewModel.petsPage + 1,
                                search: viewModel.query
                            )
                        }
                    }
                    
                    Divider()
                }
            }
            if viewModel.isPetsLoadingMore {
                ProgressView()
                    .padding(.vertical, 12)
            }
        }
    }
    
    // MARK: - Helpers
    func closePopup() {
        showPopup = false
        tabRouter.isTabBarHidden = false
    }
    
    func closeReportPopup() {
        viewModel.showReportPopup = false
        tabRouter.isTabBarHidden = false
    }
    
    func closePostReportPopup() {
        showReportPostPopUp = false
        tabRouter.isTabBarHidden = false
    }
}

// MARK: - Preview
#Preview {
    DiscoverView()
}
