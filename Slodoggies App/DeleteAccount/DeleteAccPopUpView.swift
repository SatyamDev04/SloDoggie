//
//  DeleteAccPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import SwiftUI

struct DeleteAccountPopUpView: View {
   // @Binding var isPresented: Bool
    @State private var deleteText: String = ""
    
    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                   // isPresented = false
                }

            VStack(spacing: 20) {
                // Trash icon
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.teal)
                    .padding(.top, 20)

                // Title
                Text("Are you sure you want to delete your account?")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Subtext
                Text("This action is permanent and will erase all your saved reflections and progress.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                // Confirmation instruction
                Text("Please type “DELETE” to confirm")
                    .font(.footnote)
                    .foregroundColor(.blue)

                // Text field for typing "DELETE"
                TextField("", text: $deleteText)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Buttons
                HStack {
                    Button("Cancel") {
                       // isPresented = false
                    }
                    .foregroundColor(.black)
                    .padding()
                    
                    Spacer()
                    
                    Button("Delete") {
                        // Handle deletion
                        print("Account deleted")
                        //isPresented = false
                    }
                    .disabled(deleteText != "DELETE")
                    .padding()
                    .background(deleteText == "DELETE" ? Color.teal : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding([.horizontal, .bottom])
            }
            .background(.white)
            .cornerRadius(16)
            .padding()
            .frame(maxWidth: 340)
        }
    }
}

#Preview{
    DeleteAccountPopUpView()
}
