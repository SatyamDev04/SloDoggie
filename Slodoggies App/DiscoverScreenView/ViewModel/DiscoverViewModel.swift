//
//  DiscoverViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import SwiftUI
import Combine
import GoogleMaps
import GooglePlaces

class DiscoverViewModel: ObservableObject {

    // MARK: - Common
    @Published var query: String = ""
    @Published var categories: [String] = ["Pets Near You", "Events", "Pet Places", "Activities"]
    @Published var selectedCategory: String = "Pets Near You"
    @Published var showActivity = false

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Pets Near You
    @Published var petsNearYou: [PetNearYouAPIModel] = []
    @Published var petsPage = 1
    @Published var petsLimit = 20
    @Published var totalPets = 0
    @Published var totalPetsPages = 1
    @Published var isPetsLoading = false
    @Published var isPetsLoadingMore = false

    // MARK: - Events
    @Published var events: [DiscoverEventItem] = []
    @Published var eventsPage = 1
    @Published var eventsLimit = 20
    @Published var eventTotalPage = 1
    @Published var eventCount = "0"
    @Published var isEventsLoading = false
    @Published var isEventsLoadingMore = false

    // MARK: - Activities
    @Published var activities: [PostActivitiesItem] = []
    @Published var activitiesPage = 1
    @Published var activitiesLimit = 20
    @Published var activitiesTotalPage = 1
    @Published var activitiesCount = "0"
    @Published var isActivitiesLoading = false
    @Published var isActivitiesLoadingMore = false

    // MARK: - Pet Places
    @Published var petPlaces: [PetPlace] = []
    @Published var petPlacesPage = 1
    @Published var petPlacesTotalPages = 1
    @Published var petPlacesCount = "0"
    @Published var PetPlacesLoading = false
    @Published var petPlacesLoadingMore = false
    
    // MARK: - Trending Hashtags
    @Published var trendingHashtags: [TrendingHashtag] = []
    @Published var trendingHashtagText: String = ""
    @Published var showError = false
    @Published var errorMessage: String?
    
    // MARK: - Data
    //  @Published var events: [DiscoverEventItem] = []
    @Published var showSavedPopup: Bool = false
    @Published var showReportPopup: Bool = false
    
    // Only ONE menu at a time
    @Published var activeMenuEventId: String? = nil
    
    // Selected event for actions
    @Published var selectedEvent: DiscoverEventItem? = nil
    
    @Published var isLoading: Bool = false
    @Published var showPostReportPopUp: Bool = false

    // MARK: - Actions
    func openMenu(for event: DiscoverEventItem) {
        activeMenuEventId = event.userId
    }
    
    func closeMenu() {
        activeMenuEventId = nil
    }
    
    func report(event: DiscoverEventItem) {
        selectedEvent = event
        showReportPopup = true
        closeMenu()
    }
    
    func showSaved() {
        showSavedPopup = true
    }
    
    // MARK: - Init
    init() {
        setupSearchListener()
        selectCategory("Pets Near You")
    }

    private func setupSearchListener() {
        $query
            .debounce(for: .milliseconds(400), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                guard let self else { return }

                self.searchAcrossCategories(searchText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Category Selection
    func selectCategory(_ category: String) {
        query = ""

        selectedCategory = category

        switch category {
        case "Pets Near You":
            fetchPetNearYou(page: 1, search: query)
            fetchTrendingHashtag()

        case "Events":
            fetchEvents(page: 1, search: query)

        case "Activities":
            fetchActivities(page: 1, search: query)

        case "Pet Places":
            fetchPetPlaces(page: 1)

        default:
            break
        }
    }

    func searchAcrossCategories(_ search: String) {
        switch selectedCategory {
        case "Pets Near You":
            fetchPetNearYou(page: 1, search: search)

        case "Events":
            fetchEvents(page: 1, search: search)

        case "Activities":
            fetchActivities(page: 1, search: search)

        case "Pet Places":
            fetchPetPlaces(search: search, page: 1)

        default:
            break
        }
    }
    
    // MARK: - Pets Near You API
    func fetchPetNearYou(page: Int, search: String) {

        // 🔒 HARD STOP: no more pages
        guard page == 1 || page <= totalPetsPages else { return }

        // 🔒 PREVENT DUPLICATE CALLS
        if isPetsLoading || isPetsLoadingMore {
            return
        }

        // First page
        if page == 1 {
            petsPage = 1
            totalPetsPages = 1
            petsNearYou.removeAll()
            isPetsLoading = true
        }
        // Pagination
        else {
            isPetsLoadingMore = true
        }

        showActivity = page == 1

        APIManager.shared
            .getPetNearYou(
                lat: "lat",
                long: "long",
                search: search,
                page: page
            )
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.showActivity = false
                self.isPetsLoading = false
                self.isPetsLoadingMore = false

                if case .failure(let error) = completion {
                    print("PetNearYou Error:", error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self, response.success == true else { return }

                let data = response.data
                let pets = data?.pets ?? []

                self.totalPets = data?.total ?? 0
                let limit = max(1, data?.limit ?? 1)
                self.totalPetsPages = Int(
                    ceil(Double(self.totalPets) / Double(limit))
                )

                if page == 1 {
                    self.petsNearYou = pets
                } else {
                    self.petsNearYou.append(contentsOf: pets)
                }

                self.petsPage = page
            }
            .store(in: &cancellables)
    }



    // MARK: - Events API
    func fetchEvents(page: Int, search: String) {

        if page == 1 {
            eventsPage = 1
            events.removeAll()
            isEventsLoading = true
        } else {
            guard !isEventsLoadingMore, page <= eventTotalPage else { return }
            isEventsLoadingMore = true
        }

        showActivity = true

        APIManager.shared
            .getDiscoverEvents(
                user_id: UserDetail.shared.getUserId(),
                page: page,
                search: search,
                userType: "Owner"
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false
                self.isEventsLoading = false
                self.isEventsLoadingMore = false
            } receiveValue: { response in
                guard response.success ?? false else { return }

                let data = response.data
                let total = data?.total
                let limit = data?.limit

                self.eventTotalPage = Int(ceil(Double(total ?? 0) / Double(limit ?? 0)))

                if page == 1 {
                    self.events = data?.items ?? []
                } else {
                    self.events.append(contentsOf: data?.items ?? [])
                }

                self.eventsPage = page
            }
            .store(in: &cancellables)
    }


    // MARK: - Activities API
    func fetchActivities(page: Int, search: String) {

        if page == 1 {
            activitiesPage = 1
            activities.removeAll()
            isActivitiesLoading = true
        } else {
            guard !isActivitiesLoadingMore, page <= activitiesTotalPage else { return }
            isActivitiesLoadingMore = true
        }

        showActivity = true

        APIManager.shared
            .getDiscoverActivities(id: "1", page: page, search: search)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false
                self.isActivitiesLoading = false
                self.isActivitiesLoadingMore = false
            } receiveValue: { response in
                guard response.success ?? false else { return }

                let data = response.data
                let total = data?.totalCount ?? 0
                let limit = data?.limit ?? 1

                self.activitiesTotalPage = Int(ceil(Double(total) / Double(limit)))

                if page == 1 {
                    self.activities = data?.items ?? []
                } else {
                    self.activities.append(contentsOf: data?.items ?? [])
                }

                self.activitiesPage = page
            }
            .store(in: &cancellables)
    }


    // MARK: - Pet Places API
    func fetchPetPlaces(search: String = "", page: Int = 1) {

        // Reset for new search / first page
        if page == 1 {
            petPlacesPage = 1
            petPlacesTotalPages = 1
            petPlaces.removeAll()
            PetPlacesLoading = true
        } else {
            // Pagination guard
            guard !petPlacesLoadingMore, page <= petPlacesTotalPages else { return }
            petPlacesLoadingMore = true
        }

        showActivity = page == 1

        APIManager.shared
            .getPetPlaces(id: "1", search: search, page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.showActivity = false
                self.PetPlacesLoading = false
                self.petPlacesLoadingMore = false

                if case .failure(let error) = completion {
                    print("PetPlaces Error:", error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                guard let self,
                      response.success ?? false,
                      let data = response.data else { return }

                // Total pages calculation
                self.petPlacesTotalPages = Int(
                    ceil(Double(data.total) / Double(max(1, data.limit)))
                )

                // Append / Replace
                if page == 1 {
                    self.petPlaces = data.petPlaces
                } else {
                    self.petPlaces.append(contentsOf: data.petPlaces)
                }

                // IMPORTANT
                self.petPlacesPage = page
            }
            .store(in: &cancellables)
    }
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

    // MARK: - Trending Hashtag API
    func fetchTrendingHashtag() {

        showActivity = true

        APIManager.shared
            .getTrendingHashtag()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                guard response.success ?? false else {
                    self.showError = true
                    self.errorMessage = response.message
                    return
                }
                self.trendingHashtags = response.data ?? []
            }
            .store(in: &cancellables)
    }
    // MARK: - Like / Unlike
    func likeUnlikeApi(postId: String, index: Int, postType: String) {
        self.showActivity = true
        APIManager.shared.LikeUnlikeApi(postId: postId, postType: postType)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }

                let isLiked = self.events[index].itemsuccess?.isLiked ?? false
                let currentLikes = self.intValue(self.events[index].engagement?.likes)

                self.events[index].itemsuccess?.isLiked = !isLiked
                self.events[index].engagement?.likes = .integer(
                    isLiked ? max(currentLikes - 1, 0) : currentLikes + 1)
            }
            .store(in: &cancellables)
    }
    
    func saveUnsaveApi(postId: String, index: Int, postType: String) {
        self.showActivity = true
        APIManager.shared.SaveUnsaveApi(postId: postId, postType: postType)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }

                if postType == "Activity" {
                    let current = self.activities[index].itemsuccess?.isSave ?? false
                    self.activities[index].itemsuccess?.isSave = !current
                }
              else if postType == "Event" {
                    let current = self.events[index].itemsuccess?.isSave ?? false
                    self.events[index].itemsuccess?.isSave = !current
                }else {
                    let current = self.events[index].itemsuccess?.isSave ?? false
                    self.events[index].itemsuccess?.isSave = !current }
           
            }
            .store(in: &cancellables)
    }
    
    func likeUnlikeActivityApi(postId: String, index: Int, postType: String) {
        self.showActivity = true
        APIManager.shared.LikeUnlikeApi(postId: postId, postType: postType)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }

                let isLiked = self.activities[index].itemsuccess?.isLiked ?? false
                let currentLikes = self.intValue(self.activities[index].engagement?.likes)

                self.activities[index].itemsuccess?.isLiked = !isLiked
                self.activities[index].engagement?.likes = .integer(
                    isLiked ? max(currentLikes - 1, 0) : currentLikes + 1)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Follow / Unfollow
    func FollowUnfollowApi(index: String, Index1: Int) {
        self.showActivity = true
        APIManager.shared.FollowUnfollowApi(followerID: index)
            .sink { _ in } receiveValue: { response in
                self.showActivity = false
                guard response.success == true else { return }
                let current = self.activities[Index1].itemsuccess?.iAmFollowing ?? false
                self.activities[Index1].itemsuccess?.iAmFollowing = !current
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
}
//
//// MARK: - FOLLOW / UNFOLLOW
//func followUnfollowUser(userId: String, index: Int) {
//    
//    APIManager.shared
//        .FollowUnfollowApi(followerID: userId)
//    //.followUnfollow(userId: userId)
//        .receive(on: DispatchQueue.main)
//        .sink { completion in
//            if case .failure(let error) = completion {
//                print("Follow error:", error.localizedDescription)
//            }
//        } receiveValue: { [weak self] response in
//            guard let self, response.success == true else { return }
//            
//            self.events[index].itemsuccess.userFollowMe?.toggle()
//        }
//        .store(in: &cancellables)
//}
//
//// MARK: - LIKE / UNLIKE (REUSED)
//func likeUnlikeEvent(postId: String, index: Int) {
//    self.showActivity = true
//    
//    APIManager.shared
//        .LikeUnlikeApi(postId: postId, postType: "Event")
//        .receive(on: DispatchQueue.main)
//        .sink { _ in } receiveValue: { [weak self] response in
//            guard let self, response.success == true else { return }
//            self.showActivity = false
//            
//            var isLiked = self.events[index].itemsuccess.isLiked ?? false
//            let currentLikes = self.events[index].engagement.likes
//            
//            self.events[index].itemsuccess.isLiked = !isLiked
//            //.ItemSuccessE.isLiked? = !isLiked
//            self.events[index].engagement.likes =
//            isLiked ? max((currentLikes ?? 0) - 1, 0) : (currentLikes ?? 0) + 1
//        }
//        .store(in: &cancellables)
//}
//}
