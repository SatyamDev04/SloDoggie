//
//  JoinThePackView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//


import SwiftUI

struct JoinAsView: View {
    @State private var selectedRole: Role? = nil
    @EnvironmentObject private var coordinator: Coordinator
    @State private var hideButton: Bool = false
    
    @State private var showDisclaimerPop = false
    
    enum Role {
        case professional
        case owner
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 32) {
                let loginSuccess = UserDefaults.standard.string(forKey: "loginSuccess")
                if loginSuccess == "loginSuccess"{
                    
                }else{
                    HStack{
                        Button(action: {
                            coordinator.pop()
                        }) {
                            Image("Back")
                                .foregroundColor(Color(hex: "#258694"))
                                .padding(.top, 5)
                        }
                        Spacer()
                    }
                    .padding(.leading, 25)
                    .padding(.trailing, 25)
                }
                
                Spacer()
                    .frame(height: 100)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: "#258694"))
                    .frame(width: 87, height: 6)
                
                VStack(spacing: 12) {
                    Text("Join the Pack")
                        .font(.custom("Outfit-Bold", size: 24))
                        .foregroundColor(.black)
                    
                    Text("Pick your path—because every star needs a stage, and every service has a story.")
                        .font(.custom("Outfit-Regular", size: 17))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                
                HStack(spacing: 40) {
                    RoleOptionView(
                        selectedImageName: "ProfessionalTapped",
                        unselectedImageName: "ProfessionalUntap",
                        title: "Pet Professional",
                        isSelected: selectedRole == .professional
                    )
                    .onTapGesture {
                        selectedRole = .professional
                        UserDefaults.standard.set("Professional", forKey: "userType")
                        
                        withAnimation {
                            showDisclaimerPop = true
                        }
                        //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        //                        coordinator.push(.loginView)
                        //                    }
                    }
                    RoleOptionView(
                        selectedImageName: "OwnerTapped",
                        unselectedImageName: "OwnerUntap",
                        title: "Pet Owner",
                        isSelected: selectedRole == .owner
                    )
                    .onTapGesture {
                        selectedRole = .owner
                        UserDefaults.standard.set("Owner", forKey: "userType")
                        
                            coordinator.push(.loginView)
                        
                    }
                }
                
                .padding(.top, 40)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Image("PawImg")
                        .padding(.bottom, 12)
                }
                .padding(.horizontal)
                
            }
            .onAppear {
                let userType = UserDefaults.standard.string(forKey: "saveLogin")
                if userType == "save" {
                    hideButton = true
                }
                selectedRole = nil   // Reset when view appears again
            }
            // Disclaimer Popup
        }
        .overlay(
            Group {
                if showDisclaimerPop {
                    DisclaimerPopUpView(onCancel: {
                        showDisclaimerPop = false
                        coordinator.push(.loginView)
                    })
                    .zIndex(1)
                }
            }
        )
    }
}

struct RoleOptionView: View {
    let selectedImageName: String
    let unselectedImageName: String
    let title: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color(hex: "#258694") : Color.clear, lineWidth: 2)
                    )
                    .frame(width: 80, height: 80)
                
                Image(isSelected ? selectedImageName : unselectedImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
            }
            
            Text(title)
                .font(.custom("Outfit-Medium", size: 18))
                .foregroundColor(isSelected ? Color(hex: "#258694") : .black)
        }
      }
    }


#Preview {
    JoinAsView()
}
