//
//  FAQsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//


import SwiftUI

struct FAQsView: View {
    @StateObject private var viewModel = FAQViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom Header
            HStack(spacing: 12) {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Text("FAQs")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#221B22"))
                
                Spacer()
            }
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(viewModel.faqItems.indices, id: \.self) { index in
                        VStack(spacing: 0) {
                            Button(action: {
                                viewModel.toggleExpansion(for: index)
                            }) {
                                HStack {
                                    Text(viewModel.faqItems[index].question)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: viewModel.isExpanded(index: index) ? "chevron.up" : "chevron.down")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color(hex: "#258694"))
                                .clipShape(
                                    RoundedCorner(
                                        radius: 10,
                                        corners: viewModel.isExpanded(index: index) ? [.topLeft, .topRight] : [.allCorners]
                                    )
                                )
                            }
                            .buttonStyle(PlainButtonStyle()) // remove default button styling
                            
                            if viewModel.isExpanded(index: index),
                               !viewModel.faqItems[index].answer.isEmpty {
                                Text(viewModel.faqItems[index].answer)
                                    .font(.custom("Outfit-Regular", size: 15))
                                    .foregroundColor(Color(hex: "#252E32"))
                                    .padding()
                                    .background(Color(hex: "#E5EFF2"))
                                    .clipShape(RoundedCorner(radius: 10, corners: [.bottomLeft, .bottomRight]))
                                    .transition(.opacity)
                            }
                        }
                        .animation(.easeInOut, value: viewModel.expandedIndex)
                        .padding(.horizontal)
                        .padding(.leading, 10)
                    }
                }
                .padding(.vertical)
             }
            .background(Color(.systemGroupedBackground))
         }
        .navigationBarHidden(true)
     }
  }

#Preview {
    FAQsView()
}
