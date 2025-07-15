//
//  CustomTextfildes.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)

            TextField(placeholder, text: $text)
                .font(.custom("Outfit-Regular", size: 15))
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
        }
    }
}

struct CustomDropdownField: View {
    let title: String
    @Binding var text: String
    @Binding var placeholderTxt: String
    @Binding var isPickerPresented: Bool
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)

            Button(action: {
                isPickerPresented.toggle()
            }) {
                HStack {
                    Text(text.isEmpty ? placeholderTxt : text)
                        .font(.custom("Outfit-Regular", size: 15))
                        .foregroundColor(text.isEmpty ? Color(hex: "#949494") : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.4)))
            }

            if isPickerPresented {
                Picker("", selection: $text) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
            }
        }
    }
}
