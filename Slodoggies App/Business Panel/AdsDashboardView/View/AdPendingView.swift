//
//  AdPendingView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 14/10/25.
//

import SwiftUI

struct AdPendingView: View {
    var backAction : () -> () = {}
    
    var body: some View {
        ZStack {
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.top)
                .padding(.trailing, 45)
                
                VStack(spacing: 20) {
                    Image("fluentdone")
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                    
                    Text("Your ad is under review!")
                        .font(.custom("Outfit-Medium", size: 18))
                    
                    Text("Your ad is now under review by the admin team.")
                        .font(.custom("Outfit-Regular", size: 15))
                        .multilineTextAlignment(.center)
                    
                    Text("You will receive a notification once it is approved and live.")
                        .font(.custom("Outfit-Regular", size: 15))
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        backAction()
                    }) {
                        Text("Go to Dashboard")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#258694"))
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 10)
                .frame(width: 320)
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    AdPendingView(
//        isVisible: .constant(true)
//        backAction: {
//            print("Popup closed")
//        }
    )
}
