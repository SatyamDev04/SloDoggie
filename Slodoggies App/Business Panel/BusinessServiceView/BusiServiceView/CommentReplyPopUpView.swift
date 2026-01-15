//
//  CommentReplyPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 02/09/25.
//

import SwiftUI

struct CommentReplyPopupView: View {
    
    @Binding var isPresented: Bool
    @State private var replyText: String = ""
    
    var onSubmit: (String) -> Void
    
    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Spacer()
                    Button(action: {
                        isPresented = false
                        //backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.trailing, 45)
                
                // Popup Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Reply")
                        .font(.headline)
                    
                    TextEditor(text: $replyText)
                        .frame(height: 100)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                        .overlay(
                            Group {
                                if replyText.isEmpty {
                                    Text("Write your reply....")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 10)
                                        .padding(.top, 12)
                                        .allowsHitTesting(false)
                                }
                            }, alignment: .topLeading
                        )
                    
                    HStack {
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("Cancel")
                                .foregroundColor(.black)
                                .fontWeight(.medium)
                                .padding(.leading, 60)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            onSubmit(replyText)
                            isPresented = false
                        }) {
                            Text("Submit Reply")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color(hex: "#258694"))
                                .cornerRadius(8)
                                .padding(.trailing, 20)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: 350)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 8)
            }
        }
    }
}
