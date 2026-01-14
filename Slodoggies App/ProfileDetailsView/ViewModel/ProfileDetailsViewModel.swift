//
//  DetailsViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/08/25.
//

import Foundation
import Combine

class ProfileDetailsViewModel: ObservableObject {
    @Published var pets: [PetsDetailData] = []
    @Published var selectedPet: PetsDetailData?
    @Published var user: OwnerDetails?
    @Published var galleryItems: [PostGalleryList] = []
    @Published var galleryResponse: PostGalleryData?
    @Published var data: OwnerProfileDetail?
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    @Published var petName: String? = ""
    
    @Published var page = 1
    @Published var totalPage = 1
    @Published var isLoadingMore = false
    
    func ProfileDetailsApi(userId: String) {
        self.showActivity = true
        APIManager.shared.getOwnerProfileApi(UserId: userId)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.data = response.data
                    self.pets = self.data?.pets ?? []
                    
                    if let name = self.petName, !name.isEmpty {
                        self.selectedPet = self.pets.first { $0.petName == name }
                    } else {
                        self.selectedPet = self.pets.first
                    }

                    self.user = self.data?.owner
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
    func loadInitialData(userId:String) {
        getGalleryApi(userid:userId, page: self.page)
    }
    
    // MARK: LOAD MORE ON SCROLL
    func loadMoreIfNeeded(userId:String, currentItem item: PostGalleryList) {
        guard let lastItem = galleryItems.last else { return }
        
        // Load more ONLY when the last item appears
        if item.id == lastItem.id {
            guard !isLoadingMore, page < totalPage else { return }
            
            page += 1
            getGalleryApi(userid:userId, page: page)
        }
    }
    
    func getGalleryApi(userid:String,page: Int) {
        guard !isLoadingMore else { return }
        guard page <= totalPage else { return }
        
        self.isLoadingMore = true
        APIManager.shared.getOwnerGallery(userID:userid, page: "\(self.page)")
            .sink { completionn in
                self.isLoadingMore = false
                if case .failure(let error) = completionn {
                    print("Failed to retrive saved list with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
//                    completion(false)
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.galleryResponse = response.data
                    self.totalPage = self.galleryResponse?.totalPage ?? 1
                    
                    if self.page == 1 {
                        self.galleryItems = self.galleryResponse?.data ?? []
                    } else {
                        self.galleryItems.append(contentsOf: self.galleryResponse?.data ?? [])
                    }
                    
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
//                    completion(false)
                }
                
            }.store(in: &cancellables)
       }
}
