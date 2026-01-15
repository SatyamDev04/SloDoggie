//
//  ReportUserPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 12/08/25.
//

import SwiftUI

struct ReportUserBottomSheetView: View {
    @State private var selectedReason: String? = nil
    @State private var message: String = ""
    @State private var feedbackMessage: String = ""
    var reportOn: String
    @Binding var isPresented: Bool
    
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
                    .onTapGesture {
                        isPresented = false
                    }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            isPresented = false
                        }) {
                            Image("crossIcon")
                                .resizable()
                                .frame(width: 35, height: 35)
                                .foregroundColor(Color.blue)
                        }
                        .padding(.trailing, 12)
                    }
                    
//                  .padding(.top)
                    VStack(spacing: 10) {
                        HStack {
                            Text("Report User")
                                .font(.custom("Outfit-Medium", size: 20))
                            Spacer()
                        }
                        .padding()
                        .padding(.bottom, -10)
                        
                        Divider()
                            .frame(height: 2)
                            .background(Color(hex: "#258694"))
                        
                        // Question
                        Text("Why are you reporting this comment?")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        // Reasons List
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(reasons, id: \.self) { reason in
                                Button(action: { selectedReason = reason }) {
                                    HStack {
                                        Text(reason)
                                            .font(.custom("Outfit-Regular", size: 14))
                                            .foregroundColor(.black)
                                        Spacer()
                                        if selectedReason == reason {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(Color(hex: "#258694"))
                                         }
                                     }
//                                    .padding(.vertical, 6)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        // Message Box
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Message (Optional)")
                                .font(.custom("Outfit-Medium", size: 14))
                                .foregroundColor(.black)
                                .padding(.top, 4)
                            
                            PlaceholderTextEditor(placeholder: "Write something here....", text: $message)
                                .frame(height: 120)
                        }

                        .padding(.horizontal)
       
                        // Buttons
                        HStack {
                            Button(action: {
                                isPresented = false
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
                                isPresented = false
                               // onSubmit()
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

#Preview {
    ReportUserBottomSheetView(reportOn: "Comment", isPresented: .constant(true))
}
