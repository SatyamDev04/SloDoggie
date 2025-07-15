//
//  HelpSupportViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation
import SwiftUI

class HelpSupportViewModel: ObservableObject {
    @Published var items: [SupportItem] = []
    
    init() {
        items = [
            SupportItem(
                type: .contact,
                title: "Need a paw? We're here for you!",
                message: "Whether you're having trouble with your profile, reporting a bug, or just need help finding features, our support team is ready to assist.",
                phone: "(555) 123 456",
                email: "help@slodoggies.com"
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
}
