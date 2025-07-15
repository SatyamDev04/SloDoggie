//
//  HelpSupportView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import SwiftUI

struct HelpSupportView: View {
    @StateObject private var viewModel = HelpSupportViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack(spacing: 12) {
                Button(action: {
                    // Action for back
                }) {
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Text("Help & Support")
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
            
            // Content
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(viewModel.items) { item in
                        HelpSupportCardView(item: item, viewModel: viewModel)
                    }
                    
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
            }
            //.background(Color(.systemGroupedBackground).ignoresSafeArea()) // optional
         }
       }
     }

struct HelpSupportCardView: View {
    let item: SupportItem
    let viewModel: HelpSupportViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            Text(item.title)
                .font(.custom("Outfit-Medium", size: 17))
                .foregroundColor(.black)
            
            Text(item.message)
                .font(.custom("Outfit-Regular", size: 15))
                .foregroundColor(.black)
            
            if item.type == .contact {
                VStack(alignment: .leading, spacing: 22) {
                    HStack(spacing: 10) {
                        Image("Phone 1")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.teal)
                        
                        Spacer()
                        Button(action: {
                            viewModel.callNumber(item.phone ?? "")
                        }) {
                            Text(item.phone ?? "")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    HStack(spacing: 10) {
                        Image("Email")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.teal)
                        
                        Spacer()
                        Button(action: {
                            viewModel.openEmail(item.email ?? "")
                        }) {
                            Text(item.email ?? "")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            } else if item.type == .faq {
                Text("Check out our ") +
                Text("[FAQ section]")
                    .underline()
                    .foregroundColor(Color(hex: "#258694")) +
                Text(" for common questions about using the app, managing your account, or promoting your pet business.")
                    .font(.custom("Outfit-Regular", size: 15))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .padding(.leading, 14)
        .padding(.trailing, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(hex: "#258694"), lineWidth: 1)
        )
    }
}

#Preview{
    HelpSupportView()
}
