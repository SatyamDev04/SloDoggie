//
//  CustomProgressView.swift
//  Shopping
//
//  Created by Berkay Sancar on 27.07.2024.
//

import SwiftUI

struct CustomLoderView: View {
    
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            ZStack {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
                VStack {
                    LottieView(animationName: "Animation")
                        .frame(width: 100, height: 100)
                }
                .padding(0)
              
               
            }
            .allowsHitTesting(true)
        }
    }
}
#Preview {
    CustomLoderView(isVisible: .constant(true))
}
