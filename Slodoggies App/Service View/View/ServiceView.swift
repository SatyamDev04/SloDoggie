//
//  ServiceView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct ServicesView: View {
    @StateObject private var viewModel = ServicesListViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20){
                Button(action: {
                     coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Services")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
            }
            
              .padding()
//            .padding(.leading, -180)
//            .padding(.horizontal,25)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            SearchBarView()

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(viewModel.filters, id: \.self) { filter in
                        FilterChip(title: filter,
                                   isSelected: viewModel.selectedFilter == filter) {
                            viewModel.selectedFilter = viewModel.selectedFilter == filter ? nil : filter
                        }
                    }
                }.padding(.horizontal)
            }

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(viewModel.filteredProviders) { provider in
                        ProviderCardView(provider: provider)
                            .onTapGesture {
                                coordinator.push(.providerProfileView)
                            }
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    ServicesView()
}
