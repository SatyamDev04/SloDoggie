//
//  SavedPostsViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import Foundation
import Combine

class SavedPostsViewModel: ObservableObject {
    @Published var savedPostResponse:SavedPostResponse?
    @Published var savedPostList:[SavedPostDataModel] = []
    @Published var showError = false
    @Published var errorMessage: String?
    @Published var page = 1
    @Published var totalPage = 1
    @Published var isLoadingMore = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadInitialData()
    }

    func loadInitialData() {
        page = 1
        savedPostList.removeAll()
        getSavedPostListApi(page: page)
    }

    func loadMoreIfNeeded(currentItem item: SavedPostDataModel) {
        guard let index = savedPostList.firstIndex(where: { $0.id == item.id }) else { return }

        let thresholdIndex = savedPostList.index(savedPostList.endIndex, offsetBy: -1)

        if index == thresholdIndex {
            // last item → load next page
            if page < totalPage && !isLoadingMore {
                page += 1
                getSavedPostListApi(page: page)
            }
        }
    }


    func getSavedPostListApi(page: Int) {

        guard !isLoadingMore else { return }

        isLoadingMore = true

        APIManager.shared.getSavedPostListApi(page: "\(page)")
            .sink { completion in
                self.isLoadingMore = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success ?? false {
                    self.savedPostResponse = response.data
                    self.totalPage = self.savedPostResponse?.totalPage ?? 1
                    
                    let newItems = self.savedPostResponse?.data ?? []
                    
                    if page == 1 {
                        self.savedPostList = newItems
                    } else {
                        self.savedPostList.append(contentsOf: newItems)
                    }
                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }
            .store(in: &cancellables)
    }
}
