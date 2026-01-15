//
//  DisclaimerPopUpView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/10/25.
//

import SwiftUI

struct DisclaimerPopUpView: View {
    var onCancel: () -> Void = {}
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack {
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        onCancel()
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.trailing, 20)
                
                VStack(spacing: 10) {
                    Image("DisclaimerIcon")
                        .scaledToFit()
                        .frame(width: 55, height: 55)
                        .foregroundColor(.blue)
                    
                    Text("Disclaimer")
                        .font(.custom("Outfit-Medium", size: 18))
                    Text("Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quao. Nemo enim ipsam voluptatem quia voluptas sit.")
                        .font(.custom("Outfit-Regular", size: 15))
                        .multilineTextAlignment(.center)
                }
                //.frame(width: .infinity, alignment: .center)
                .padding(.horizontal)
                .padding(.vertical, 45)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    DisclaimerPopUpView()
}
