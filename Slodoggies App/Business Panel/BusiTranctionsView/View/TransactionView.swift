//
//  TransactionView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 12/09/25.
//

import SwiftUI
import Combine

enum TabType {
    case adTopUps
    case subscriptions
}

// MARK: - TransactionView (Main)
struct TransactionView: View {
    @State private var selectedTab: TabType = .adTopUps
    @StateObject private var adTopUpsVM = AdTopUpsViewModel()
    @StateObject private var subscriptionVM = SubscriptionViewModel()
    @State private var showReceiptPopup = false
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack{
            VStack(spacing: 16) {
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text("Transactions")
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: " #221B22"))
                    Spacer()
                }
                
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                // MARK: - Top Tabs
                HStack(spacing: 0) {
                    tabButton("Ad Top-Ups", tab: .adTopUps)
                    tabButton("Subscriptions", tab: .subscriptions)
                }
                //.clipShape(Capsule())
                .padding(.horizontal)
                .padding(.top, 10)
                
                // MARK: - Tab Content
                ScrollView {
                    if selectedTab == .adTopUps {
                        AdTopUpsView(viewModel: adTopUpsVM, showReceiptPopup: $showReceiptPopup)
                    } else {
                        SubscriptionsView(viewModel: subscriptionVM, showReceiptPopup: $showReceiptPopup)
                    }
                }
                if selectedTab == .adTopUps {
                    // MARK: - Ad Top-Up Button
                    Button(action: {
                        // Handle Ad Top-Up action
                    }) {
                        Text("Ad Top-Up")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 2)
                    
                } else if selectedTab == .subscriptions {
                    // MARK: - Upgrade Plan Button
                    Button(action: {
                        // Handle Upgrade Plan action
                    }) {
                        Text("Upgrade Plan")
                            .font(.custom("Outfit-Medium", size: 16))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .frame(height: 42)
                            .foregroundColor(.white)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 2)
                }

            }
        }
        .overlay(
            Group {
                if showReceiptPopup {
                    ReceiptPopUpView(isPresented: $showReceiptPopup)
                }
            }
         )
      }
    
    // MARK: - Tab Button
    private func tabButton(_ title: String, tab: TabType) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(selectedTab == tab ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    (selectedTab == tab ? Color(hex: "#258694") : Color.clear)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 229/255, green: 239/255, blue: 242/255), lineWidth: 0)
                )
        }
     }
  }

// MARK: - AdTopUpsView
struct AdTopUpsView: View {
    @ObservedObject var viewModel: AdTopUpsViewModel
    @Binding var showReceiptPopup: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Summary
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    summaryCard(title: "Total Spent", value: "$\(String(format: "%.2f", viewModel.totalSpent))")
                    summaryCard(title: "Current Plan", value: "\(viewModel.currentPlan)")
                    summaryCard(title: "End Date", value: "\(viewModel.endDate)")
                }
                HStack(spacing: 12) {
                    summaryCard(title: "Successful", value: "\(viewModel.successfulCount)")
                    summaryCard(title: "Pending/Failed", value: "\(viewModel.failedCount)")
                }
            }
            
            // Transactions
            ForEach(viewModel.transactions) { transaction in
                VStack(spacing: 8) {
                    transactionCard(transaction)
                        .padding(.bottom, -10)
                    Button(action:{
                        showReceiptPopup = true
                        print("Receipt tapped")
                    }){
                        Text("View Receipt")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#258694"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color(red: 229/255, green: 239/255, blue: 242/255), lineWidth: 1) // border color here
                            )
                    }
                }
            }
        }
        .padding()
    }
    
    private func summaryCard(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.custom("Outfit-Medium", size: 12))
                .foregroundColor(.black)
                .padding(1)
            Text(value)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color(hex: "#258694"))
                .padding(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(10)
        .background(Color.white)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 229/255, green: 239/255, blue: 242/255), lineWidth: 1) // border color here
            )
      }
    
    private func transactionCard(_ transaction: TransactionModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transaction.title)
                    .font(.custom("Outfit-SemiBold", size: 14))
                Spacer()
                Text("$\(String(format: "%.2f", transaction.amount))")
                    .font(.custom("Outfit-SemiBold", size: 14))
            }
            HStack {
                Text("ID: \(transaction.transactionId)   \(transaction.date)")
                    .font(.custom("Outfit-Regular", size: 12))
                Spacer()
                statusLabel(transaction.status)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
    }
    
    private func statusLabel(_ status: TransactionModel.Status) -> some View {
        let (text, color): (String, Color) = {
            switch status {
            case .successful: return ("Successful", .green)
            case .renewed: return ("Renewed", .green)
            case .failed: return ("Failed", .red)
            }
        }()
        
        return Text(text)
            .font(.custom("Outfit-Medium", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(6)
    }
}

// MARK: - SubscriptionsView
struct SubscriptionsView: View {
    @ObservedObject var viewModel: SubscriptionViewModel
    @Binding var showReceiptPopup: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Summary
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    summaryCard(title: "Total Spent", value: "$\(String(format: "%.2f", viewModel.summary.totalSpent))")
                    summaryCard(title: "Current Plan", value: viewModel.summary.currentPlan)
                    summaryCard(title: "Next Renewal", value: viewModel.summary.endDate)
                }
                HStack(spacing: 12) {
                    summaryCard(title: "Successful", value: "\(viewModel.summary.successfulCount)")
                    summaryCard(title: "Pending/Failed", value: "\(viewModel.summary.failedCount)")
                }
            }
            
            // Transactions
            ForEach(viewModel.transactions) { transaction in
                VStack(spacing: 8) {
                    transactionCard(transaction)
                        .padding(.bottom, -10)
                    Button("Receipt") {
                        showReceiptPopup = true
                        print("Receipt tapped")
                    }
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#258694"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 38)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 229/255, green: 239/255, blue: 242/255), lineWidth: 1) // border color here
                    )
                }
            }
        }
        .padding()
    }
    
    private func summaryCard(title: String, value: String) -> some View {
        VStack {
            Text(title)
                .font(.custom("Outfit-Medium", size: 12))
                .foregroundColor(.black)
                .padding(1)
            Text(value)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(Color(hex: "#258694"))
                .padding(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 229/255, green: 239/255, blue: 242/255), lineWidth: 1) // border color here
            )
      }
    
    private func transactionCard(_ transaction: TransactionModel) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(transaction.title)
                    .font(.custom("Outfit-SemiBold", size: 14))
                Spacer()
                Text("$\(String(format: "%.2f", transaction.amount))")
                    .font(.custom("Outfit-SemiBold", size: 14))
            }
            HStack {
                Text("ID: \(transaction.transactionId)   \(transaction.date)")
                    .font(.custom("Outfit-Regular", size: 12))
                Spacer()
                statusLabel(transaction.status)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
       // .shadow(radius: 2)
    }
    
    private func statusLabel(_ status: TransactionModel.Status) -> some View {
        let (text, color): (String, Color) = {
            switch status {
            case .successful: return ("Successful", .green)
            case .renewed: return ("Renewed", .green)
            case .failed: return ("Failed", .red)
            }
        }()
        
        return Text(text)
            .font(.custom("Outfit-Medium", size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color)
            .cornerRadius(6)
    }
}

#Preview {
    TransactionView()
}
