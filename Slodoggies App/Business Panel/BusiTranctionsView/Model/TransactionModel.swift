//
//  TransactionModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 12/09/25.
//

import SwiftUI
import Combine
import Foundation

// MARK: - Transaction Model
struct TransactionModel: Identifiable {
    let id = UUID()
    let title: String
    let transactionId: String
    let date: String
    let amount: Double
    let status: Status
    
    enum Status {
        case successful
        case renewed
        case failed
    }
}

// MARK: - Subscription Summary
struct SubscriptionSummary {
    let totalSpent: Double
    let currentPlan: String
    let endDate: String
    let successfulCount: Int
    let failedCount: Int
}
