//
//  ReportPostPopUp.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 10/10/25.
//

import SwiftUI

struct ReportPostPopUp: View {
    @State private var selectedReason: String? = nil
    @State private var message: String = ""
    @State private var feedbackMessage: String = ""
    var reportOn: String
    let reasons = [
        "Bullying or unwanted contact",
        "Violence, hate or exploitation",
        "False Information",
        "Scam, fraud or spam"
    ]
    var onCancel: (() -> Void)
    //var onSubmit: (() -> Void)
    
    var onSubmit: (_ reason: String, _ message: String) -> Void
    
    var body: some View {
            ZStack {
                // Dimmed background
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture { onCancel() }
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        Button(action: {
                            onCancel()
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
                            Text("Report Post")
                                .font(.custom("Outfit-Medium", size: 20))
                            Spacer()
                        }
                        .padding()
                        .padding(.bottom, -10)
                        
                        Divider()
                            .frame(height: 2)
                            .background(Color(hex: "#258694"))
                        
                        // Question
                        Text("Why are you reporting this post?")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                        
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
                        .padding(.bottom, 8)
                        
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
                                onCancel()
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
                               // onSubmit()
                                onSubmit("\(selectedReason ?? "")", message)
                            }) {
                                Text("Send report")
                                    .font(.custom("Outfit-Medium", size: 15))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .foregroundColor(.white)
                                   // .background(Color(hex: "#258694"))
                                    .background(
                                               (selectedReason?.isEmpty ?? true)
                                               ? Color.gray.opacity(0.5)   // Disabled color
                                               : Color(hex: "#258694")     // Enabled color
                                           )
                                    .cornerRadius(12)
                            }
                            .disabled(selectedReason?.isEmpty ?? true)
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

//struct PlaceholderTextEditor: View {
//    var placeholder: String
//    @Binding var text: String
//
//    var body: some View {
//        ZStack(alignment: .topLeading) {
//            // Placeholder
//            if text.isEmpty {
//                Text(placeholder)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal, 16)
//                    .padding(.vertical, 12)
//                    .font(.custom("Outfit-Medium", size: 14))
//            }
//
//            // Actual TextEditor
//            TextEditor(text: $text)
//                .padding(.horizontal, 12)
//                .padding(.vertical, 8)
//                .scrollContentBackground(.hidden) // hides default background (iOS 16+)
//                .background(Color.clear)
//                .font(.custom("Outfit-Regular", size: 15))
//        }
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//        )
//    }
//}

 #Preview {
     ReportPostPopUp(reportOn: "Comment",onCancel: {},onSubmit: {reason,message in })
 }
