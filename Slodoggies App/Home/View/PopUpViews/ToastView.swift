//
//  ToastView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/08/25.
//

import SwiftUI

struct ToastView: View {
    var onCancel: (() -> Void)
    var body: some View {
        ZStack{
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {  }
            
            VStack{
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text("Report Sent!")
                            .font(.custom("Outfit-Regular", size: 14))
                        
                        Divider().frame(width: 1,height: 18)
                            .background(Color(hex: "#258694"))
                        
                        Text("Admin will get back to you.")
                            .font(.custom("Outfit-Regular", size: 14))
                        
                        Spacer()
                        
                        Button(action: {
                            onCancel()
                        }) {
                            Image("SmallBlueCancel")
                                .foregroundColor(Color(hex: "#258694"))
                                .frame(width: 17, height: 17)
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(30)
            }
        }
    }
}

#Preview {
    ToastView(onCancel: {})
}
