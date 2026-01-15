//
//  AccountPrivacyView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 08/09/25.
//

import SwiftUI

struct AccountPrivacyView: View {
    @StateObject private var viewModal = AccountPrivacyViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State var deleteAccountPopView: Bool = false
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                Text("Account Privacy")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: "#221B22"))
                Spacer()
                //.padding(.leading, 100)
            }
            
            .padding(.horizontal,20)
            .padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    Text(viewModal.accountPrivacyText)
                        .font(.custom("Outfit-Regular", size: 18))
                        .foregroundColor(Color(hex: "#252E32"))
                        .padding(.leading, 35)
                        .padding(.trailing, 35)
                        .padding(.top, 20)
                    
                    Divider()
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    
                    VStack(spacing: 16) {
                        accountPrivacyRow(title: "Change Password".localized(), image: "changepasswordicon", showArrow: false) {
                            coordinator.push(.forgotPassword)
                        }
                        
                        Divider()
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        
                        accountPrivacyRow(title: "Delete Account".localized(), image: "deleteIcon 1", showArrow: false){
                            deleteAccountPopView = true
                        }
                        
                        Divider()
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        
                    }
                    .padding(.top)
                    .padding(.leading)
                }
            }
        }
        .overlay(
            Group {
                if deleteAccountPopView {
                    DeleteAccountPopUpView(isPresented: $deleteAccountPopView)
                }
             }
          )
        }
     }

private func accountPrivacyRow(title: String, image: String, showArrow: Bool = false, action: @escaping () -> Void) -> some View {
    Button(action: action) {
        HStack {
            Image(image)
                .resizable()
                .frame(width: 22, height: 22) // Increased icon size
            Text(title)
                .font(.custom("Outfit-Regular", size: 18)) // Increased font size
                .foregroundColor(.black)
            Spacer()
            Spacer()
            if showArrow {
                Image("RightArrowIcon")
                   // .foregroundColor(.gray)
            }
          }
        .foregroundColor(.black)
        .padding(.horizontal)
     }
  }

 #Preview{
    AccountPrivacyView()
 }
