//
//  ProviderViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import Foundation

class ProviderProfileViewModel: ObservableObject {
    @Published var provider: ProviderModel
    @Published var selectedTab: Tab = .services

    enum Tab {
        case services
        case reviews
    }

    init() {
        self.provider = MockData.provider
    }

    func toggleFollow() {
        var updatedProvider = provider
        updatedProvider.isFollowing.toggle()
        provider = updatedProvider
    }
}
