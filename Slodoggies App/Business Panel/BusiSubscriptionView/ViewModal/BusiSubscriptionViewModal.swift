//
//  BusiSubscriptionViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/08/25.
//

import SwiftUI

class BusiSubscriptionViewModal: ObservableObject {
    @Published var selectedPlan: String = "Standard"
    
    let plans: [BusiSubscriptionModal] = [
        BusiSubscriptionModal(
            name: "Standard",
            price: "$49/month",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            features: ["Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum"]
        ),
        BusiSubscriptionModal(
            name: "Basic",
            price: "$29/month",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            features: ["Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum"]
        ),
        BusiSubscriptionModal(
            name: "Premium",
            price: "$99/month",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
            features: ["Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum", "Lorem Ipsum"]
        )
    ]
    
    func selectPlan(_ plan: BusiSubscriptionModal) {
        if selectedPlan == plan.name {
            selectedPlan = "" // Cancel if already selected
        } else {
            selectedPlan = plan.name
        }
    }
    
    func cancelSelection() {
        selectedPlan = ""
    }
}
