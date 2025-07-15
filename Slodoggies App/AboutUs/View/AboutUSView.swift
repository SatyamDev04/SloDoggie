//
//  AboutUSView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import SwiftUI

struct AboutUSView: View {
    @StateObject private var viewModal = AboutUsViewModel()
    
    var body: some View {
        Spacer()
        HStack(spacing: 20){
            Button(action: {
                
            }){
                Image("Back")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Text("About Us")
                .font(.custom("Outfit-Medium", size: 20))
                .fontWeight(.medium)
                .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
        }
        .padding(.leading, -180)
        .padding(.horizontal,25)
        .padding(.bottom,2)
        
        Divider()
            .frame(height: 2)
            .background(Color(hex: "#258694"))
        
        VStack(alignment: .leading, spacing: 16) {
            ScrollView {
                Text(viewModal.aboutUsText)
                    .font(.custom("Outfit-Regular", size: 18))
                    .foregroundColor(Color(hex: "#252E32"))
                    .padding(.leading, 35)
                    .padding(.trailing, 35)
                    .padding(.top, 20)
            }
        }
    }
}

#Preview{
    AboutUSView()
}
