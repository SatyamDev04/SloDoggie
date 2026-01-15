//
//  BusiReportUserPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 26/08/25.
//

import SwiftUI

struct BusiReportUserPopUpView: View {
    @Binding var isPresented: Bool
    @State private var selectedReason: String? = nil
    @State private var message: String = ""
    @State private var reason = ""
    @State private var showReasonPicker = false
    @State private var feedbackMessage: String = ""
    var reportOn:String
    let reasons = [
        "Bullying or unwanted contact",
        "Violence, hate or exploitation",
        "False Information",
        "Scam, fraud or spam"
    ]
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture { isPresented = false } // 👈 close popup
            VStack{
                Spacer()
                HStack{
                    Spacer()
                    Button(action: {
                        isPresented = false // 👈 close popup
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                    .padding(.trailing, 12)
                }
                
                VStack(spacing: 10) {
                    HStack {
                        Text("Report")
                            .font(.custom("Outfit-Medium", size: 20))
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, -10)
                    
                    Divider()
                        .frame(height: 2)
                        .background(Color(hex: "#258694"))
                        .padding(.horizontal)
                    
                    DropdownSelector(
                        title: "Reasons",
                        text: $reason,
                        placeholderTxt: "Select",
                        isPickerPresented: $showReasonPicker,
                        options: reasons
                    )
                    .padding(.horizontal)
                    
                    // Message Box
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Message (Optional)")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        
                        PlaceholderTextEditor(placeholder: "Write something here....", text: $message)
                            .frame(height: 120)
                    }
                    .padding(.horizontal)
                    
                    // Buttons
                    HStack {
                        Button(action: {
                            isPresented = false // 👈 close popup
                        }) {
                            Text("Cancel")
                                .font(.custom("Outfit-Medium", size: 15))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.black)
                                .cornerRadius(12)
                        }
                        
                        Button(action: {
                            print("Report submitted: \(selectedReason ?? "") - \(message)")
                            isPresented = false // 👈 close popup after submit
                        }) {
                            Text("Send report")
                                .font(.custom("Outfit-Regular", size: 14))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .background(Color.white)
                .cornerRadius(16)
                .padding(10)
            }
        }
        .padding(.bottom, -20)
    }
}


// MARK: - Preview
#Preview {
    BusiReportUserPopUpView(isPresented: .constant(true), reportOn: "BusiComment")
}

