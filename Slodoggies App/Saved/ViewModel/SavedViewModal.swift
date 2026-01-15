//
//  SavedViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI
import Combine
class SavedViewModel: ObservableObject {

    @Published var savedDataResponse: SavedPostsData?
    @Published var savedList: [SavedPostItem] = []
    @Published var mediaItems: [MediaItem] = []
    @Published var selectedIndex: Int? = nil

    @Published var page = 1
    @Published var totalPage = 1
    @Published var isLoadingMore = false
    @Published var showActivity = false
    @Published var videoThumbnails: [String: UIImage] = [:]
    @Published var showError = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()

    init() {
        loadInitialData()
    }

    func selectItem(at index: Int) {
        selectedIndex = index
    }

    func closeViewer() {
        selectedIndex = nil
    }

    func loadInitialData() {
        guard !showActivity else { return } // prevent double loader

        page = 1
        
        savedList.removeAll()
        mediaItems.removeAll()
        getSavedListApi(page: page)
    }

    func getSavedListApi(page: Int) {
        guard !isLoadingMore else { return }
        showActivity = true
        isLoadingMore = true
       
        APIManager.shared.getSavedAllListApi(page: "\(page)")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.showActivity = false // 🔑 always stop loader
                self.isLoadingMore = false

                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.savedDataResponse = response.data
                if page == 1 {
                    self.savedList = self.savedDataResponse?.items ?? []
                } else {
                    self.savedList.append(contentsOf: self.savedDataResponse?.items ?? [])
                }
                self.prepareMediaItems(from: self.savedList)
            }
            .store(in: &cancellables)
    }


    // MARK: - LOAD MORE
    func loadMoreIfNeeded(currentItem item: SavedPostItem) {
        guard let lastItem = savedList.last else { return }

        if item.id == lastItem.id {
            guard !isLoadingMore, page < totalPage else { return }
            page += 1
            getSavedListApi(page: page)
        }
    }

}

extension SavedViewModel {

    func prepareMediaItems(from posts: [SavedPostItem]) {
        mediaItems = posts.compactMap { post in
            guard let firstMedia = post.postMedia.first else {
                return nil
            }

            let isVideo = firstMedia.type.lowercased() == "video"

            let thumbnail = isVideo
                ? (firstMedia.thumbnailUrl ?? firstMedia.mediaUrl ?? "")
                : (firstMedia.mediaUrl ?? "")

            return MediaItem(
                mediaType: isVideo ? .video : .image,
                thumbnail: thumbnail,
                videoURL: isVideo ? firstMedia.mediaUrl : nil
            )
        }
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
