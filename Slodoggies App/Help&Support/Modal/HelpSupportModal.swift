//
//  HelpSupportModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation

enum SupportItemType {
    case contact
    case faq
    case feedback
}

struct SupportItem: Identifiable {
    let id = UUID()
    let type: SupportItemType
    let title: String
    let message: String
    let phone: String?
    let email: String?
}

