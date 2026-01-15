//
//  EmptyPetCardView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/07/25.
//
import SwiftUI

struct EmptyPetCardView: View {
    let uID: String
    
    var body: some View {
            HStack(alignment: .top, spacing: 16) {
                
                // Pet Image Circle
                Image("NoPetImg")   // Replace with your asset
//                        .resizable()
//                        .scaledToFit()
                    .frame(width: 70, height: 70)
//                        .opacity(0.6)
//                ZStack {
//                    Circle()
//                        .fill(Color.gray.opacity(0.15))
////                        .frame(width: 70, height: 70)
//                    
//                   
//                }
                
                VStack(alignment: .leading, spacing: 6) {
                    // Pet Name + Edit Button
                    HStack {
                        Text("Pet name")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(hex: "#221B22"))
                        
                        Spacer()
                        if uID == UserDetail.shared.getUserId(){
                            Image("PencilIcons")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "#258694"))
                        }
                    }
                    
                    HStack(spacing: 8) {
                        // Breed pill
                        Text("Breed")
                            .font(.system(size: 13))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: "#7A7A7A"))
                        
                        // Age pill
                        Text("Age")
                            .font(.system(size: 13))
                            .padding(.horizontal, 25)
                            .padding(.vertical, 6)
                            .background(Color.gray.opacity(0.15))
                            .cornerRadius(20)
                            .foregroundColor(Color(hex: "#7A7A7A"))
                    }
                    
                    Text("Bio")
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "#7A7A7A"))
                        .padding(.top, 2)
                }
            }
            .padding(25)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 4)
            .padding(.horizontal)
        }
}
#Preview {
    EmptyPetCardView(uID: "")
}
