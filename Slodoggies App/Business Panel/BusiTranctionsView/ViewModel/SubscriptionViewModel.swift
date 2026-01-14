//
//  TransactionViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 12/09/25.
//

import Combine
import SwiftUI

class AdTopUpsViewModel: ObservableObject {
    @Published var totalSpent: Double = 85.0
    @Published var successfulCount: Int = 5
    @Published var failedCount: Int = 1
    @Published var  currentPlan = "Standard"
    @Published var  endDate: String = "Oct 12, 2025"
    @Published var transactions: [TransactionModel] = [
        TransactionModel(title: "Ad Top-Up", transactionId: "ATU-1001", date: "08/01/2025", amount: 20, status: .successful),
        TransactionModel(title: "Ad Top-Up", transactionId: "ATU-1002", date: "08/15/2025", amount: 30, status: .successful),
        TransactionModel(title: "Ad Top-Up", transactionId: "ATU-1003", date: "09/01/2025", amount: 35, status: .failed)
    ]
}

// MARK: - Subscription ViewModel
class SubscriptionViewModel: ObservableObject {
    @Published var summary = SubscriptionSummary(
        totalSpent: 165.0,
        currentPlan: "Standard",
        endDate: "Oct 12, 2025",
        successfulCount: 8,
        failedCount: 2
    )
    
    @Published var transactions: [TransactionModel] = [
        TransactionModel(title: "Standard Plan", transactionId: "SUB-82341", date: "09/15/2025", amount: 25, status: .renewed),
        TransactionModel(title: "Standard Plan", transactionId: "SUB-81234", date: "08/15/2025", amount: 25, status: .successful)
    ]
}
