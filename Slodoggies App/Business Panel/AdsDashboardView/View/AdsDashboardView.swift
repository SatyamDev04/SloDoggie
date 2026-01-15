//
//  AdsDashboardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import SwiftUI

struct AdsDashboardView: View {
    @StateObject private var viewModel = AdsDashboardViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showPendingPopup = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                
                // MARK: Header
                HStack(spacing: 20) {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                   
                    Text("Sponsored Ads Dashboard")
                        .font(.custom("Outfit-Medium", size: 20))
                        .foregroundColor(Color(hex: "#221B22"))
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                // MARK: - Segmented Control
                CustomSegmentedControl(selectedTab: $viewModel.selectedTab)
                    .onChange(of: viewModel.selectedTab) { newValue in
                        // 👇 When user switches to Pending tab, show popup
                        if newValue == .pending {
                            withAnimation(.easeInOut) {
                                showPendingPopup = true
                            }
                        }
                    }
                
                // MARK: - Ads List
                ScrollView {
                    VStack(spacing: 16) {
                        let filteredAds = viewModel.ads.filter { $0.status.tabType == viewModel.selectedTab }
                        let filteredMoreAds = viewModel.moreAds.filter { $0.status.tabType == viewModel.selectedTab }
                        
                        // Main list
                        ForEach(filteredAds) { ad in
                            AdCardView(ad: ad, onPendingTap: {
                                if ad.status == .pending {
                                    withAnimation(.easeInOut) {
                                        showPendingPopup = true
                                    }
                                }
                            })
                        }
                        
                        // Additional list
                        ForEach(filteredMoreAds) { ad in
                            AdCardView(ad: ad, onPendingTap: {
                                if ad.status == .pending {
                                    withAnimation(.easeInOut) {
                                        showPendingPopup = true
                                    }
                                }
                            })
                        }
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Search Experience Rules")
                                .font(.custom("Outfit-Medium", size: 16))
                            RulesSectionView()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            
            // MARK: - Popup Overlay
            if showPendingPopup {
                AdPendingView {
                    showPendingPopup = false
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    AdsDashboardView()
}

struct AdCardView: View {
    let ad: AdsDashboardModel
    var onPendingTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack {
                Text(ad.title)
                    .font(.custom("Outfit-Medium", size: 18))
                
                Spacer()
                
                Text(ad.status.rawValue)
                    .font(.custom("Outfit-Semibold", size: 11))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 10)
                    .background(
                        ad.status == .expired
                        ? Color(hex: "#9C9C9C") // Grey for expired
                        : ad.status == .live
                        ? Color(hex: "#44ED11")
                        : ad.status == .approved
                        ? Color.clear// Green for live
                        : Color(Color(red: 206/255, green: 206/255, blue: 225/255)) // Yellow/Orange for Under Review
                    )
                    .foregroundColor(
                        ad.status == .expired || ad.status == .live
                        ? .white
                        : Color.black // Black text for Under Review
                    )
                    .cornerRadius(8)
              }
            
            // MARK: - Different Layouts Based on Status
            if ad.status == .expired {
                Text("No engagement data available")
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.black)
                
                Button(action: {
                    
                }) {
                    Text("Ad Run Again")
                        .frame(maxWidth: .infinity)
                        .frame(height: 38)
                        .background(Color(hex: "#258694"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
                
            }else if ad.status == .approved {
                Text("No engagement data available")
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.black)
                
                HStack(spacing: 12) {
                    Button(action: {
                        // Handle Pay Now
                    }) {
                        Text("Pay Now")
                            .font(.custom("Outfit-Medium", size: 14))
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(Color(hex: "#258694"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                }
                .padding(.top)

            } else if ad.status == .pending {
                VStack(alignment: .leading, spacing: 8) {
                    Text("No engagement data available")
                        .font(.custom("Outfit-Regular", size: 12))
                        .foregroundColor(.black)
                    
                    Button(action: {
                        onPendingTap?() // trigger popup
                    }) {
                        Text("View Status")
                            .frame(maxWidth: .infinity)
                            .frame(height: 38)
                            .background(Color(hex: "#258694"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                }
            } else {
                //  Normal stats for live
                Text("Clicks : \(ad.clicks)  |  Impressions : \(ad.impression)")
                    .font(.custom("Outfit-Regular", size: 16))
                    .foregroundColor(.black)
                
                HStack {
                    Image("messageIcon")
                        .resizable()
                        .frame(width: 19, height: 19)
                    
                    Text("Message Leads : \(ad.messageLeads)")
                        .font(.custom("Outfit-Regular", size: 14))
                        .foregroundColor(.black)
                }
                
                HStack(spacing: 12) {
                    Text("Expiry Date: \(ad.expiryDate)")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(Color(hex: "#258694"))
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }) {
                        Text("Stop")
                            .frame(width: 96, height: 43)
                            .background(Color(hex: "#258694"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .padding()
        .background(Color(red: 229/255, green: 239/255, blue: 242/255))
        .cornerRadius(12)
      }
   }

struct InvoiceCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Date
            Text("June 4, 2025")
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(.black)
            
            // Leads info
            Text("50 Leads in $100")
                .font(.custom("Outfit-Semibold", size: 12))
                .foregroundColor(.black)
            
            // Download button
            Button(action: {
                // Handle invoice download
            }) {
                Text("Download Invoice")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694")) // teal color
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(red: 229/255, green: 239/255, blue: 242/255)) // light blue background
        .cornerRadius(12)
    }
}

struct RulesSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            VStack(alignment: .leading, spacing: 8) {
                RuleItem(text: "Top 3 results reserved for sponsored ads (marked as ‘Sponsored’).")
                RuleItem(text: "Based on category relevance & rotation/fixed purchase order.")
                RuleItem(text: "Ads appear only if live, approved, and within budget.")
                RuleItem(text: "Hidden once expired or budget is exhausted.")
                RuleItem(text: "Real-time Tap to Call and Message options.")
            }
        }
        .padding()
        .background(Color(red: 229/255, green: 239/255, blue: 242/255))
        .cornerRadius(12)
        //.shadow(radius: 4, y: 2)
    }
}

struct RuleItem: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Circle()
                .frame(width: 6, height: 6)
                .foregroundColor(.black)
                .padding(.top, 6)
            
            Text(text)
                .font(.custom("Outfit-Regular", size: 14))
                .foregroundColor(.black)
        }
    }
}
