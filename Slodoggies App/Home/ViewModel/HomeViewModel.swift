//
//  HomeViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var showWelcomPopUp: Bool = true
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = ""
    
}
