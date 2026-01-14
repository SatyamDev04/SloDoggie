//
//  EditParticipantsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/07/25.
//

import SwiftUI

struct EditParticipantsView: View {
    @Binding var isPresented: Bool
    @State private var isRemoveUserPopupPresented = false
       var onRemoveUser: () -> Void = {}
       var onViewProfile: () -> Void = {}

       var body: some View {
           VStack(spacing: 0) {
               Capsule()
                   .fill(Color.gray.opacity(0.5))
                   .frame(width: 40, height: 5)
                   .padding(.top, 8)
               
               Button(action: {
                   onRemoveUser()
                   isPresented = false
               }) {
                   HStack {
                       Image("RemoveUser")
                           .resizable()
                           .frame(width: 20, height: 20)
                       Text("Remove User")
                           .font(.custom("Outfit-Medium", size: 15))
                           .padding(.leading, 6)
                       Spacer()
                   }
                   .padding()
               }
               .buttonStyle(PlainButtonStyle())

               Button(action: {
                   onViewProfile()
                   isPresented = false
               }) {
                   HStack {
                       Image("ViewProfile")
                           .resizable()
                           .frame(width: 20, height: 20)
                       Text("View Profile")
                           .font(.custom("Outfit-Medium", size: 15))
                           .padding(.leading, 6)
                       Spacer()
                   }
                   .padding()
               }
               .buttonStyle(PlainButtonStyle())

               Spacer(minLength: 0)
           }
           .background(Color.white)
           .cornerRadius(14)
           .ignoresSafeArea(edges: .bottom)
       }
    }

  #Preview {
     EditParticipantsView(isPresented: .constant(true))
   }
