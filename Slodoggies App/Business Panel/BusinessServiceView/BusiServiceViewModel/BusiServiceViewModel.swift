//
//  BusiServiceViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import Foundation

//class BusiServiceViewModel: ObservableObject {
//    @Published var provider: BusiServiceModel
//    @Published var selectedTab: Tab = .services
//    
//    @Published var reviews: [BusiServiceReview] = [
//        BusiServiceReview(
//            id: UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!,
//            reviewerName: "Courtney Henry",
//            rating: 5,
//            comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation.",
//            timeAgo: "2 mins ago",
//            reply: ReviewReply(
//                authorName: "Rosy Morgan",
//                role: "Provider",
//                time: "Just now",
//                text: "Thanks so much for the kind words, Courtney! We're thrilled your pup enjoyed their visit. 🐾"
//            ), canReply: false
//        ),
//        BusiServiceReview(
//            id: UUID(),
//            reviewerName: "Cameron Williamson",
//            rating: 4,
//            comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.",
//            timeAgo: "5 mins ago", canReply: false
//        )
//    ]
//    
//    enum Tab {
//        case services
//        case reviews
//    }
//
////    init() {
////        self.provider = BusiServiceMockData.provider
////    }
//
//    func toggleFollow() {
//        var updatedProvider = provider
//        updatedProvider.isFollowing.toggle()
//        provider = updatedProvider
//    }
//}


import Foundation
import Combine
import UIKit
 
class BusinessServiceViewModel: ObservableObject {
   
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = ""
    
   // @Published var selectedTab: Tab = .services
    
    @Published var selectedTab: Tab = .services

    @Published var businessServiceResponse: BusinessServiceModel?
    
    // 🔥 ADD THESE
      @Published var reviews: [BusiServiceReview] = []
      @Published var ratingCounts: [Int] = [0, 0, 0, 0, 0] // 5 → 1
      @Published var averageRating: Double = 0
      @Published var totalReviews: Int = 0
   
    private var cancellables = Set<AnyCancellable>()
    

    func getBusinessServiceDetails() {
        self.isLoading = true
        APIManager.shared.getBussinessServiceDetails(businessID: Int(UserDetail.shared.getUserId()))
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success ?? false {
                    
                    self.businessServiceResponse = response.data
                    print(self.businessServiceResponse, "getBusinessServiceDetails")
                    
                    
                    guard let ratings = response.data?.ratingsAndReviews else { return }

                          // ⭐ Summary
                    self.averageRating = Double(ratings.averageRating ?? "") ?? 0.0
                          self.totalReviews = ratings.totalReviews ?? 0

                          let dist = ratings.ratingDistribution ?? [:]
                          self.ratingCounts = [
                              dist["5"] ?? 0,
                              dist["4"] ?? 0,
                              dist["3"] ?? 0,
                              dist["2"] ?? 0,
                              dist["1"] ?? 0
                          ]

                          // 📝 Reviews
                          self.reviews = (ratings.reviews ?? []).map { review in
                              BusiServiceReview(
                                  id: UUID(),
                                  reviewerName: review.user?.name ?? "",
                                  rating: review.rating ?? 0,
                                  comment: review.comment ?? "", timeAgo: review.timeAgo ?? "",
                                  reply: review.replies?.first.map {
                                      ReviewReply(
                                          authorName: $0.user?.name ?? "",
                                          role: "Provider",
                                          time: $0.timeAgo ?? "",
                                          text: $0.comment ?? ""
                                      )
                                  },
                                  canReply: review.canReply ?? false,
                                  createdAt: review.createdAt ?? "",
                                  reviewId: review.reviewID ?? 0,
                                  user: review.user
                              )
                          }
                    
                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }
            .store(in: &cancellables)
    }
    
    func deleteService(serviceId: String, index: Int) {
        isLoading = true

        APIManager.shared.deleteBusinessService(serviceid: serviceId)
            .sink { completion in
                self.isLoading = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                if response.success ?? false {

                    // ✅ REMOVE LOCALLY (smooth UX)
                    self.businessServiceResponse?.services?.remove(at: index)

                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Delete failed"
                }
            }
            .store(in: &cancellables)
    }

    
    
    enum Tab {
        case services
        case reviews
    }


}
