//
//  AboutUSView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import SwiftUI

struct AboutUSView: View {
    @StateObject private var viewModel = AboutUsViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading){
                Spacer()
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
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
                //                .padding(.leading, -170)
                .padding(.horizontal,25)
                .padding(.bottom,2)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                VStack(alignment: .leading, spacing: 16) {
                    ScrollView {
                        Text(viewModel.aboutUsText)
                            .font(.custom("Outfit-Regular", size: 18))
                            .foregroundColor(Color(hex: "#252E32"))
                            .padding(.leading, 35)
                            .padding(.trailing, 35)
                            .padding(.top, 20)
                    }
                }
            }
            .onAppear(){
                viewModel.getAboutUsdata()
            }
            
            if viewModel.showActivity {
                CustomLoderView(isVisible: $viewModel.showActivity)
                    .ignoresSafeArea()
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
    }
}

#Preview{
    AboutUSView()
}
