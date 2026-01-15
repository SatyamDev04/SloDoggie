//
//  ServiceView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct ServicesView: View {
    
    @StateObject private var viewModel = ServiceFilterChipViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var tabRouter: TabRouter
    
    var body: some View {
        VStack(alignment: .leading) {
            
            header
            
            Divider()
                .background(Color(hex: "#258694"))
            
            SearchBarView(searchText: $viewModel.searchText)

            categoryChips
            
            Text("Top Providers")
                .font(.custom("Outfit-SemiBold", size: 14))
                .padding(.leading, 12)
                .padding(.top, 10)
            
            providersGrid
        }
        .onAppear {
            viewModel.fetchCategories()
            viewModel.fetchProviders()
        }
    }
    
    private var header: some View {
        HStack {
            Button {
                tabRouter.selectedTab = .home
            } label: {
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            
            Text("Services")
                .font(.custom("Outfit-Medium", size: 20))
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(viewModel.categories) { category in
                    FilterChip(
                        title: category.categoryName ?? "N/A",
                        isSelected: viewModel.selectedCategory == category.categoryName
                    ) {
                        // Toggle category
                        viewModel.selectedCategory =
                            viewModel.selectedCategory == category.categoryName
                            ? nil
                            : category.categoryName

                        // Clear search text
                        viewModel.searchText = ""
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    private var providersGrid: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 16
            ) {
                ForEach(viewModel.filteredServiceProviders) { provider in
                    ProviderCardView(provider: provider)
                        .onTapGesture {
                            coordinator.push(.providerProfileView(provider.providerId ?? 0))
                        }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ServicesView()
}
