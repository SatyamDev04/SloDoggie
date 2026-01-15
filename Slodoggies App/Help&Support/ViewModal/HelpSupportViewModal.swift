//
//  HelpSupportViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation
import SwiftUI
import Combine

class HelpSupportViewModel: ObservableObject {
    @Published var items: [SupportItem] = []
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    
    init() {
        items = [
            SupportItem(
                type: .contact,
                title: "Need a paw? We're here for you!",
                message: "",
                phone: "",
                email: ""
            ),
            SupportItem(
                type: .faq,
                title: "Need Quick Answers?",
                message: "",
                phone: nil,
                email: nil
            ),
            SupportItem(
                type: .feedback,
                title: "Feedback & Suggestions",
                message: "We’d love to hear from you! Help us make Slodoggies better by sharing your feedback and ideas.",
                phone: nil,
                email: nil
            )
        ]
    }
    
    func callNumber(_ number: String) {
        let cleaned = number.replacingOccurrences(of: " ", with: "")
        guard let url = URL(string: "tel://\(cleaned)") else { return }
        UIApplication.shared.open(url)
    }
    
    func openEmail(_ email: String) {
        guard let url = URL(string: "mailto:\(email)") else { return }
        UIApplication.shared.open(url)
    }
    
    func getHelpSupporstDatadata() {
        self.showActivity = true
        APIManager.shared.getHelpSupport()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.items[0].message = response.data?.content?.htmlStripped() ?? ""
                    self.items[0].email = response.data?.email ?? ""
                    self.items[0].phone = response.data?.phone ?? ""
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
}
