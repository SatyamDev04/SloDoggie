//
//  FAQViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation
import SwiftUI

class FAQViewModel: ObservableObject {
    @Published var faqItems: [FAQItem] = []
    @Published var expandedIndex: Int? = 0 // First item expanded by default

    init() {
        loadFAQData()
    }

    func loadFAQData() {
        faqItems = [
            FAQItem(question: "What is Slodoggies?",
                    answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "Who can join Slodoggies?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "How do I create a profile?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "Is there a cost to use the app?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "Can I create events or meetups?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "How do I promote my pet business?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "How is my information used?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses."),
            FAQItem(question: "How do I contact support?", answer: "Slodoggies is a community-driven app for pet lovers and service providers in San Luis Obispo County. Share pet moments, discover local events, and connect with pet-friendly businesses.")
        ]
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
