//
//  BusiProfileViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import Foundation
import Combine
import UIKit
 
class BusiProfileViewModal: ObservableObject {
    @Published var isLoading: Bool = false  // full-screen loader
    @Published var isProfileLoading = false   // skeleton control
    @Published var isGalleryLoading = false   // skeleton control
    
    @Published var showError: Bool = false
    @Published var errorMessage: String? = ""
    @Published var videoThumbnails: [String: UIImage] = [:]
    @Published var Busipets: [BusiPet] = []
    @Published var BusiselectedPet: BusiPet?
    @Published var Busiuser: BusiUser?
   // @Published var BusigalleryItems: [BusiGalleryItem] = []
    @Published var GalleryResponse: GalleyResponse?
    @Published var BusigalleryItems: [BusiGalleryItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    // PAGINATION
     private var currentPage = 1
     private let limit = 9
     private var isLastPage = false
     private var isFetching = false
 
 
//    init() {
//        getBussinessProfile()
//        getBussinessGalleryApi(reset: true)
//    }
 
    func getBussinessProfile(userID: String) {

        isLoading = true
        isProfileLoading = true

        APIManager.shared
            .getBussinessProfile(userID: userID)
            .receive(on: DispatchQueue.main) // ✅ REQUIRED
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false
                self.isProfileLoading = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                if response.success == true {
                    self.Busiuser = response.data
                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }
            .store(in: &cancellables)
    }

    
    
    func getBussinessGalleryApi(userId: String, reset: Bool = false) {

        if reset {
            currentPage = 1
            isLastPage = false
            isFetching = false    // 🔥 REQUIRED
            BusigalleryItems.removeAll()
        }

        guard !isFetching, !isLastPage else {
            print("⛔️ Gallery API blocked — isFetching:", isFetching, "isLastPage:", isLastPage)
            return
        }

        isFetching = true
        isGalleryLoading = true
        isLoading = currentPage == 1

        APIManager.shared
            .getGalleryItemApi(userID: userId, page: currentPage, limit: limit)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }

                self.isLoading = false
                self.isGalleryLoading = false
                self.isFetching = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }

                guard response.success == true else { return }

                let newItems = response.data?.data ?? []

                if newItems.count < self.limit {
                    self.isLastPage = true
                }

                self.BusigalleryItems.append(contentsOf: newItems)
                self.currentPage += 1
            }
            .store(in: &cancellables)
    }

    
    func loadVideoThumbnail(for url: String) {
        // Already loaded
        if videoThumbnails[url] != nil { return }

        Task {
            let image = await VideoThumbnailGenerator.shared.thumbnail(for: url)
            if let image {
                await MainActor.run {
                    self.videoThumbnails[url] = image
                }
            }
        }
    }
}
