//
//  FAQViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation
import SwiftUI
import Combine

class FAQViewModel: ObservableObject {
    @Published var faqItems: [FAQItem] = []
    @Published var expandedIndex: Int? = 0 // First item expanded by default
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false

    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil

    @Published var faqText: String = ""
    init() {
        fetchFAQData()
    }

    func fetchFAQData() {
        self.showActivity = true
        APIManager.shared.getFAQData()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.faqItems = response.data ?? []
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
       }
                                                 
    func toggleExpansion(for index: Int) {
        withAnimation {
            expandedIndex = (expandedIndex == index) ? nil : index
        }
    }

    func isExpanded(index: Int) -> Bool {
        return expandedIndex == index
    }
 }




    
