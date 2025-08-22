//
//  SettingView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI

struct SettingView: View {
    @StateObject private var viewModel = SettingsViewModel()
   // @EnvironmentObject var localizableManager: LocalizableManager
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject private var coordinator: Coordinator
    @State var logoutAccountPopView: Bool = false
    @State var deleteAccountPopView: Bool = false
    
    var body: some View {
            HStack(spacing: 20){
                Button(action: {
                     coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("Settings")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
            }
            
            //.padding()
            .padding(.leading, -180)
            //.padding(.horizontal,25)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            VStack {
                ScrollView {
                    VStack(spacing: 16) {
                        settingsRow(title: "Saved".localized(), image: "savedIcon") {
                            coordinator.push(.savedView)
                        }
                        Divider()
                        
                        settingsRow(title: "Events".localized(), image: "EventsIcon") {
                             coordinator.push(.myEvents)
                        }
                        Divider()
                        
                        notificationToggleRow
                        Divider()
                        settingsRow(title: "Delete Account".localized(), image: "deleteIcon 1") {
                            deleteAccountPopView = true
                            //viewModel.handleDeleteAccount()
                        }
                        Divider()
                        settingsRow(title: "About Us".localized(), image: "AboutIcon") {
                            coordinator.push(.aboutUs)
                        }
                        Divider()
                        settingsRow(title: "Terms & Conditions".localized(), image: "TermConditionIcon", showArrow: true) {
                            coordinator.push(.termsAndCondition)
                        }
                        Divider()
                        settingsRow(title: "Privacy Policy".localized(), image: "PrivacyPolicyIcon", showArrow: true) {
                            coordinator.push(.privacyPolicy)
                        }
                        Divider()
                        settingsRow(title: "FAQs".localized(), image: "FaqIcon") {
                            coordinator.push(.faq)
                        }
                        Divider()
                        settingsRow(title: "Help & Support".localized(), image: "HelpSupportIcon") {
                            coordinator.push(.helpSupport)
                        }
                        
                        Divider()
                        
                        Button(action: {
                            logoutAccountPopView = true
                            //viewModel.handleLogout()
                        }) {
                            HStack {
                                Label("Logout".localized(), image: "RedExitIcon")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        Divider()
                    }
                    .padding(.top, 20)
                }
                
                Spacer()
            }
            .background(Color.white)
            .onAppear {
                viewModel.checkNotificationStatus()
            }
            .onChange(of: scenePhase) { _, _ in
                viewModel.checkNotificationStatus()
            }
            
        .padding()
            .overlay(
                Group {
                    if logoutAccountPopView {
                        LogoutAccountPopUpView(isPresented: $logoutAccountPopView)
                    }

                    if deleteAccountPopView {
                        DeleteAccountPopUpView(isPresented: $deleteAccountPopView)
                    }
                }
            )
         }
    
            // MARK: - UI Rows
            private func settingsRow(title: String, image: String, showArrow: Bool = false, action: @escaping () -> Void) -> some View {
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

            private var notificationToggleRow: some View {
                HStack {
                    Label("Notification".localized(), image: "NotificationIcon")
                    Spacer()
                    Toggle("", isOn: Binding<Bool>(
                        get: { viewModel.isNotificationEnabled },
                        set: { _ in viewModel.openNotificationSettings() }
                    ))
                    .toggleStyle(SwitchToggleStyle(tint: .teal))
                 }
                .padding(.leading, -6)
                .padding(.horizontal)
            }
         }

   #Preview{
      SettingView()
    }
