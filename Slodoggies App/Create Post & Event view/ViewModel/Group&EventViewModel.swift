//
//  Group&EventViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import Foundation

enum PostTab {
    case post, event
}

class CreatePostViewModel: ObservableObject {
    @Published var selectedTab: PostTab = .post
}
