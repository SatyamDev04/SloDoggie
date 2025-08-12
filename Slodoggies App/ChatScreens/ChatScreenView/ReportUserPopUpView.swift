//
//  ReportUserPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 12/08/25.
//

import SwiftUI

struct ReportUserBottomSheetView: View {
    @Binding var isPresented: Bool
    @State private var selectedReason: String? = nil
    @State private var message: String = ""
    
    let reasons = [
        "Bullying or unwanted contact",
        "Violence, hate or exploitation",
        "False Information",
        "Scam, fraud or spam"
    ]
    
    var body: some View {
        ZStack {
            // Dimmed background
            if isPresented {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { isPresented = false }
            }
            
            // Bottom sheet
            VStack(spacing: 16) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 40, height: 5)
                    .padding(.top, 8)
                
                Text("Report")
                    .font(.custom("Outfit-Medium", size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                Text("Why are you reporting this comment?")
                    .font(.custom("Outfit-Medium", size: 16))
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Reason list
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(reasons, id: \.self) { reason in
                        HStack {
//                            Image(systemName: selectedReason == reason ? "circle.inset.filled" : "circle")
//                                .foregroundColor(selectedReason == reason ? .teal : .gray)
                            Text(reason)
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        .onTapGesture {
                            selectedReason = reason
                        }
                    }
                }
                
                // Message field
                VStack(alignment: .leading, spacing: 4) {
                    Text("Message (Optional)")
                        .font(.custom("Outfit-Medium", size: 16))
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                    TextEditor(text: $message)
                        .frame(height: 80)
                        .padding(8)
                        //.background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Buttons
                HStack {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 170, height: 44)
                    
                    
                    //Spacer()
                    Button("Sent Report") {
                        isPresented = false
                    }
                    .padding()
                        .frame(width: 170, height: 44)
                        .font(.custom("Outfit-Bold", size: 15))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8, corners: .allCorners)
                  }
                .padding([.horizontal])
                .padding(.bottom, 30)
               
            }
            .padding(.leading)
            .padding(.trailing)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(16, corners: [.topLeft, .topRight])
            .shadow(radius: 8)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: isPresented ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(), value: isPresented)
        }
      }
    }


#Preview {
    ReportUserBottomSheetView(isPresented: .constant(true))
}
