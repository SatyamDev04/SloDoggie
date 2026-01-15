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
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text("Settings")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: " #221B22"))
                Spacer()
            }
            
            .padding(.horizontal, 20)
            
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
                        settingsRow(title: "Account Privacy".localized(), image: "accountpicon") {
                            coordinator.push(.accountPrivacyView)
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
                        
                        HStack{
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
                            Spacer()
                            
                        }
                    }
                    .padding(.top, 4)
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
            
        }
       // .padding()
        .overlay(
            Group {
                if logoutAccountPopView {
                    LogoutAccountPopUpView(isPresented: $logoutAccountPopView)
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
                    .frame(width: 22, height: 22)

                Text(title)
                    .font(.custom("Outfit-Regular", size: 18))
                    .foregroundColor(.black)

                Spacer()

                if showArrow {
                    Image("RightArrowIcon")
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white) // <— ensures tap covers entire area
            .contentShape(Rectangle()) // <— makes entire area tappable
        }
        .buttonStyle(PlainButtonStyle()) // <— removes default blue tint
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
