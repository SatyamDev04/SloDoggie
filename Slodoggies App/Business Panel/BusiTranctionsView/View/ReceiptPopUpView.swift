//
//  ReceiptPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/09/25.
//

import SwiftUI

struct ReceiptPopUpView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack{
            Color(red: 229/255, green: 239/255, blue: 242/255).opacity(0.5)
                .ignoresSafeArea()
          
        VStack(spacing: 0) {
            // Transaction Details
            
            HStack{
                Text("Receipt")
                    .font(.custom("Outfit-Medium", size: 18))
                    .foregroundColor(.black)
                    .padding()
                
                Spacer()
            }
            
            VStack(spacing: 12) {
                detailRow(title: "Transaction ID", value: "ATU-82341")
                DashedDivider()
                
                detailRow(title: "Description", value: "Ad Top-Up")
                DashedDivider()
                
                detailRow(title: "Date", value: "08/10/2025")
                DashedDivider()
                
                detailRow(title: "Status", value: "Successful")
                DashedDivider()
                
                detailRow(title: "Amount", value: "$25.00")
            }
            .padding()
            
            // Spacer(minLength: 20)
            
            // Close Button
            Button(action: {
                isPresented = false
            }) {
                Text("Close")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding()
        .overlay(
            // Cross button in top-right corner of popup
            Button(action: {
                isPresented = false
            }) {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(8)
                //.background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
                .padding(.top, -50)
                .padding(.trailing, 10),
                 alignment: .topTrailing
        )
    }
}
        
        // Reusable row
        @ViewBuilder
        private func detailRow(title: String, value: String) -> some View {
            HStack {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 15))
                    .foregroundColor(Color(hex: "#258694"))
                
                Spacer()
                
                Text(value)
                    .font(.custom("Outfit-Regular", size: 15))
                    .foregroundColor(.black)
               }
            }
        }

struct DashedDivider: View {
    var color: Color = .gray.opacity(0.3)
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .zero)
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
            }
            .stroke(style: StrokeStyle(lineWidth: 1, dash: [6])) // 4 = dash length
            .foregroundColor(color)
        }
        .frame(height: 1)
    }
}

#Preview {
    ReceiptPopUpView(isPresented: .constant(true))
}
