//
//  VerifyPhoneView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 14/07/25.
//

import SwiftUI

struct VerifyPhoneView: View {
    @StateObject var viewModel = VerifyPhoneViewModel()
    @EnvironmentObject private var coordinator: Coordinator
   
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 100)

            RoundedRectangle(cornerRadius: 3)
                .fill(Color(hex: "#258694"))
                .frame(width: 87, height: 6)

            VStack(spacing: 8) {
                Text("Verify Your Phone Number")
                    .font(.custom("Outfit-SemiBold", size: 18))

                Text("Please enter the 4 digit code sent to")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#949494"))

                Text(viewModel.phoneNumber)
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#258694"))
            }

            OTPFieldView(numberOfFields: 4, otp: $viewModel.otp)  // <-- Bind here

            if viewModel.showTimer {
                Text("00:\(String(format: "%02d", viewModel.timerValue))")
                    .font(.custom("Outfit-Medium", size: 14))
            }

            HStack(spacing: 4) {
                Text("Didn’t receive the code?")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.gray)

                if !viewModel.showTimer {
                    Button("Resend") {
                        viewModel.timerValue = 25
                        viewModel.showTimer = true
                        viewModel.resendEnabled = false
                        startTimer()
                    }
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(Color(hex: "#258694"))
                } else {
                    Text("Resend")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.gray)
                }
            }

            Button(action: {
                print("Verifying with OTP: \(viewModel.otp)")
                coordinator.push(.notificationpermision)
            }) {
                HStack {
                    Spacer()
                    Text("Verify")
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .padding()
                .font(.custom("Outfit-Medium", size: 15))
                .foregroundColor(.white)
                .background(
                    viewModel.isCodeComplete ? Color(hex: "#258694") : Color.gray.opacity(0.5)
                )
                .cornerRadius(10)
            }
            .disabled(!viewModel.isCodeComplete)

            Button(action: {
                coordinator.pop()
            }) {
                Image(systemName: "arrow.left")
                    .foregroundColor(Color(hex: "#258694"))
                    .padding(.top)
            }

            Spacer()

            HStack {
                Spacer()
                Image("PawImg")
                    .padding(.bottom, 12)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if viewModel.timerValue > 0 {
                viewModel.timerValue -= 1
            } else {
                viewModel.showTimer = false
                viewModel.resendEnabled = true
                timer.invalidate()
            }
        }
    }
}

#Preview {
    VerifyPhoneView()
}
