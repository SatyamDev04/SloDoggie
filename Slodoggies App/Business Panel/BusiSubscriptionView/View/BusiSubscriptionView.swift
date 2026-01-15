//
//  BusiSubscriptionView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/08/25.
//

import SwiftUI

struct BusiSubscriptionView: View {
    @StateObject private var viewModel = BusiSubscriptionViewModal()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        HStack(spacing: 20){
            Button(action: {
                 coordinator.pop()
            }){
                Image("Back")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            Text("Subscription")
                .font(.custom("Outfit-Medium", size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: " #221B22"))
            Spacer()
        }
        
        .padding(.horizontal, 20)
        
        Divider()
            .frame(height: 2)
            .background(Color(hex: "#258694"))
        
        ScrollView {
            VStack(spacing: 20) {
                ForEach(viewModel.plans) { plan in
                    PlanCard(plan: plan, viewModel: viewModel)
                }
            }
            .padding()
        }
    }
}

#Preview{
    BusiSubscriptionView()
}

struct PlanCard: View {
    let plan: BusiSubscriptionModal
    @ObservedObject var viewModel: BusiSubscriptionViewModal
    
    var isSelected: Bool {
        viewModel.selectedPlan == plan.name
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title & Price
            Text(plan.name)
                .font(.custom("Outfit-Medium", size: 16))
                .foregroundColor(isSelected ? .white : .black)
            
            Text(plan.price)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
            
            Text(plan.description)
                .font(.custom("Outfit-Medium", size: 16))
                .foregroundColor(isSelected ? .white.opacity(0.9) : .gray)
            
            Divider()
                .frame(height: 2)
                .background(Color.white)
            
            // Features
            VStack(alignment: .leading, spacing: 8) {
                ForEach(plan.features, id: \.self) { feature in
                    HStack {
                        Image(isSelected ? "checkbox" : "filledcheckbox")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(isSelected ? .white : .teal)
                        Text(feature)
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(isSelected ? .white : .black)
                    }
                }
            }
            
            // Action Buttons
            if isSelected {
                Button("Activated") {
                    // Do nothing (already selected)
                }
                .font(.custom("Outfit-Semibold", size: 18))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Button("Cancel") {
                    viewModel.cancelSelection()
                }
                .font(.custom("Outfit-Semibold", size: 18))
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 1)
                )
                
            } else {
                Button("Upgrade") {
                    viewModel.selectPlan(plan)
                }
                .font(.custom("Outfit-Semibold", size: 18))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.black, lineWidth: 1)
                )
            }
        }
        
        .padding()
        .padding(.leading)
        .padding(.trailing)
        .background(isSelected ? Color(hex: "#258694") : Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.4), radius: 8, x: 0, y: 4)
     }
  }
