//
//  OTPFieldView.swift
//  OTP Field View
//
//  Created by Jayant on 06/10/23.
//


import SwiftUI
import Combine

struct OTPFieldView: View {
    
    @FocusState private var pinFocusState: FocusPin?
    @Binding private var otp: String
    @State private var pins: [String]
    
    var numberOfFields: Int
    
    enum FocusPin: Hashable {
        case pin(Int)
    }
    
    init(numberOfFields: Int, otp: Binding<String>) {
        self.numberOfFields = numberOfFields
        self._otp = otp
        self._pins = State(initialValue: Array(repeating: "", count: numberOfFields))
    }
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<numberOfFields, id: \.self) { index in
                TextField("", text: $pins[index])
                    .modifier(OtpModifier(pin: $pins[index]))
                    .font(.custom("Outfit-Medium", size: 15))
                    .foregroundColor(.black)
                    .onChange(of: pins[index]) { newVal in
                        
                        if newVal.count == 1 {
                            // move to next box
                            if index < numberOfFields - 1 {
                                pinFocusState = .pin(index + 1)
                            }
                        }
                        else if newVal.count == numberOfFields {
                            // pasted full OTP
                            otp = newVal
                            updatePinsFromOTP()
                            pinFocusState = .pin(numberOfFields - 1)
                        }
                        else if newVal.isEmpty {
                            // stay on current field when deleting
                            // only move back if current was empty already
                            if index > 0 && pins[index].isEmpty && otp.count >= index {
                                pinFocusState = .pin(index - 1)
                            }
                        }
                        
                        updateOTPString()
                    }
                    .focused($pinFocusState, equals: .pin(index))
                    .onTapGesture {
                        pinFocusState = .pin(index)
                    }
              }
        }
        .onAppear {
            updatePinsFromOTP()
        }
    }
    
    private func updatePinsFromOTP() {
        let otpArray = Array(otp.prefix(numberOfFields))
        for (index, char) in otpArray.enumerated() {
            pins[index] = String(char)
        }
    }
    
    private func updateOTPString() {
        otp = pins.joined()
    }
}

struct OtpModifier: ViewModifier {
    @Binding var pin: String
    
    var textLimit = 1
    
    func limitText(_ upper: Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) { _ in limitText(textLimit) }
            .frame(width: 64, height: 52)
            .font(.system(size: 20))
            .background(
                Rectangle()
                    .frame(height: 2)
                    .foregroundColor(Color.gray.opacity(0.5))
                    .offset(y: 20)
            )
    }
}

struct OTPFieldView_Previews: PreviewProvider {   
    static var previews: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("VERIFICATION CODE")
                .foregroundColor(Color.gray)
                .font(.system(size: 12))
            OTPFieldView(numberOfFields: 4, otp: .constant(""))
                .previewLayout(.sizeThatFits)
        }
    }
}



