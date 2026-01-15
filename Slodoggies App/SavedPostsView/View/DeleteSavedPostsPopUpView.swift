//
//  DeleteSavedPostsPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import SwiftUI

struct DeleteSavedPostsPopUpView: View {
    @Binding var isVisible: Bool
      var backAction : () -> () = {}
     // var onRemove: () -> Void = {}
    
    var onRemove: (String) -> Void   // "Yes" or "No"
    
     var body: some View {
        if isVisible{
             ZStack {
                 // Background dimming
                 Color(hex: "#3C3C434A").opacity(0.5)
                     .ignoresSafeArea()
                 
                 VStack{
                     HStack{
                         Spacer()
                         Button(action: {
                             isVisible = false
                             onRemove("No")
                         }) {
                             Image("CancelIcon")
                                 .resizable()
                                 .frame(width: 35, height: 35)
                                 .foregroundColor(Color.blue)
                         }
                     }
                     .padding(.top)
                     .padding(.trailing,45)
                     
                     VStack(spacing: 20) {
                         Image("deleteIcon")
                             .resizable()
                             .scaledToFit()
                             .frame(width: 50, height: 50)
                             .foregroundColor(.blue)
                         //  .padding(.top, -20)
                         
                         Text("Delete Post")
                             .font(.custom("Outfit-Regular", size: 16))
                         
                         Text("Are you sure you want to delete this post?\n This action cannot be undone.")
                             .font(.custom("Outfit-Regular", size: 14))
                             .multilineTextAlignment(.center)
                         
                         HStack {
                             Button(action: {
                                 isVisible = false
                                 onRemove("Yes")
                             }) {
                                 Text("Delete")
                                     .padding()
                                     .frame(width: 140, height: 42)
                                     .font(.custom("Outfit-Medium", size: 15))
                                     .foregroundColor(.white)
                                     .background(Color(hex: "#258694"))
                                     .cornerRadius(8)
                                     .cornerRadius(8, corners: .allCorners)
                             }
                             //Spacer()
                             
                             Button(action: {
                                 isVisible = false
                                 onRemove("No")
                             }){
                                 Text("Cancel")
                                     .padding()
                                     .frame(width: 140, height: 42)
                                     .font(.custom("Outfit-Medium", size: 15))
                                     .foregroundColor(.black)
                                     .cornerRadius(8)
                                     .cornerRadius(8, corners: .allCorners)
                             }
                         }
                         .padding([.horizontal])

                     }
                     .padding(.horizontal,10)
                     .frame(width: 320)
                     .padding(.vertical)
                     .background(Color.white)
                     .cornerRadius(20)
                 }
                 
             }
       }
     }
 }

#Preview {
    DeleteSavedPostsPopUpView(
        isVisible: .constant(true), onRemove: {_ in })
        
}
