//
//  ProviderViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import Foundation
import Combine

class ProviderProfileViewModel: ObservableObject {
//    @Published var provider: BusinessServiceModel?
    @Published var selectedTab: Tab = .services
    
    @Published var serviceResponse: BusinessServiceModel?
    @Published var isLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = ""
    private var cancellables = Set<AnyCancellable>()
    
    enum Tab {
        case services
        case reviews
    }

    @Published var reviews: [BusiServiceReview] = [
        BusiServiceReview(
            id: UUID(uuidString: "12345678-1234-1234-1234-1234567890ab")!,
            reviewerName: "Courtney Henry",
            rating: 5,
            comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco exercitation.",
            timeAgo: "2 mins ago",
            reply: ReviewReply(
                authorName: "Rosy Morgan",
                role: "Provider",
                time: "Just now",
                text: "Thanks so much for the kind words, Courtney! We're thrilled your pup enjoyed their visit. 🐾"
            ), canReply: false
        ),
        BusiServiceReview(
            id: UUID(),
            reviewerName: "Cameron Williamson",
            rating: 4,
            comment: "Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullamco.",
            timeAgo: "5 mins ago", canReply: false
        )
    ]
    
    func toggleFollow() {
//        var updatedProvider = provider
//        updatedProvider.isFollowing.toggle()
//        provider = updatedProvider
    }
    
    func getServiceDetails(BusinessID:Int) {
        self.isLoading = true
        APIManager.shared.getBussinessServiceDetails(businessID: BusinessID)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success ?? false {
                    
                    self.serviceResponse = response.data
//                    print(self.serviceResponse, "getBusinessServiceDetails")
                    
                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }
            .store(in: &cancellables)
    }
    
}
