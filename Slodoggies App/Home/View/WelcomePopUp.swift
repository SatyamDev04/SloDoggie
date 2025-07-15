//
//  CongratsFreeConsPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//


import SwiftUI

struct CongratsFreeConsPopupView: View {
    @State private var navigateToHome = false
    @State private var showDialog = false
    @Binding var isVisible: Bool
    var backAction : () -> () = {}
    var appointmentDate: String
    var appointmentTime: String
    
     var body: some View {
         ZStack {
             // Background dimming
             Color.black.opacity(0.5)
                 .ignoresSafeArea()

             // Popup Card
             VStack(spacing: 20) {
                 HStack {
                     Spacer()
                     Button(action: {
                         backAction()
                     }) {
                         Image(systemName: "xmark.circle.fill")
                             .resizable()
                             .frame(width: 24, height: 24)
                             .foregroundColor(Color.blue)
                     }
                 }
                 .padding(.top)
                 .padding(.horizontal)

                 Image("Congratulation") // You can use your custom image here
//                     .resizable()
                     .scaledToFit()
                     .frame(width: 50, height: 50)
                     .foregroundColor(.blue)
                     .padding(.top, -20)

                 Text("congratulations".localized())
                     .font(.title)
                     .fontWeight(.semibold)

                 Text("first_consultation_free".localized())
                     .foregroundColor(Color(red: 53/255, green: 101/255, blue: 152/255))
                     .font(.custom("Lato", size: 20))
                     .fontWeight(.bold)

                 Text("no_payment_required_for_this_session".localized())
                     .foregroundColor(.gray)
                     .font(.subheadline)

                 HStack(spacing: 10) {
                     Text("₹449")
                         .strikethrough(true, color: Color(hex: "#199FD9"))
                         .foregroundColor(.gray)
                     Rectangle()
                         .fill(Color.gray)
                         .frame(width: 1, height: 30)
                     Text("free".localized())
                         .font(.title2)
                         .fontWeight(.semibold)
                         .foregroundColor(Color(hex: "#199FD9"))
                 }

                 Text("enjoy_your_first_consultation".localized())
                     .font(.subheadline)
                     .foregroundColor(Color(hex: "#356598"))

                 Button(action: {
                     // Thank you action
                     backAction()
                 }) {
                     Text("thank_you".localized())
                         .foregroundColor(.white)
                         .frame(maxWidth: .infinity)
                         .padding()
                         .background(Color(hex: "#F47820"))
                         .cornerRadius(8)
                 }
                 .padding(.horizontal)

//                 Spacer(minLength: 20)
             }
             .frame(width: 320)
             .padding()
             .background(Color.white)
             .cornerRadius(24)
         }
     }
 }
struct FreeConfirmationDialogDemo: View {
    @State private var showDialog = true

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            Button("Trigger Confirmation") {
                showDialog = true
            }

            CongratsFreeConsPopupView(isVisible: $showDialog, appointmentDate: "May 14, 2024 at 10:00 AM", appointmentTime: "")
        }
    }
}

struct FreeConfirmationDialogDemo_Previews: PreviewProvider {
    static var previews: some View {
        FreeConfirmationDialogDemo()
    }
}
