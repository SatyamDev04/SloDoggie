//
//  CostumDropdown.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/08/25.
//

import SwiftUI

struct DropdownSelector: View {
    let title: String
    @Binding var text: String
    let placeholderTxt: String
    @Binding var isPickerPresented: Bool
    let options: [String]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.black)
                
                // Field
                Button(action: {
                    withAnimation {
                        isPickerPresented.toggle()
                    }
                }) {
                    HStack {
                        Text(text.isEmpty ? placeholderTxt : text)
                            .font(.custom("Outfit-Regular", size: 15))
                            .foregroundColor(
                                text.isEmpty
                                ? Color.gray.opacity(0.4) // 👈 degraded placeholder
                                : .black
                            )
                        
                        Spacer()
                        Image(isPickerPresented ? "DropupIcon" : "DropdownIcon")
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal) // keep horizontal padding
                    .frame(height: 48)    // fixed height
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#9C9C9C"), lineWidth: 1)
                    )
                }
                
                // Separated dropdown options
                if isPickerPresented {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                text = option
                                withAnimation {
                                    isPickerPresented = false
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.custom("Outfit-Medium", size: 14))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.vertical, 8) // smaller height
                                .padding(.horizontal, 12)
                                .background(
                                    option == text
                                    ? Color(hex: "#258694")
                                    : Color.white
                                )
                            }
                            if option != options.last {
                                Divider()
                            }
                        }
                    }
                    .frame(maxHeight: 150) // limit dropdown height
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                    )
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4) // make it look like a popup
                }
            }
        }
    }
}


import SwiftUI

struct ScrollDropdownSelector: View {
    let title: String
    @Binding var text: String
    let placeholderTxt: String
    @Binding var isPickerPresented: Bool
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Title
            Text(title)
                .font(.custom("Outfit-Medium", size: 14))
                .foregroundColor(.black)
            
            // Field
            Button(action: {
                withAnimation {
                    isPickerPresented.toggle()
                }
            }) {
                HStack {
                    Text(text.isEmpty ? placeholderTxt : text)
                        .font(.custom("Outfit-Regular", size: 15))
                        .foregroundColor(
                            text.isEmpty
                            ? Color.gray.opacity(0.4) // degraded placeholder
                            : .black
                        )
                    
                    Spacer()
                    Image(isPickerPresented ? "DropupIcon" : "DropdownIcon")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                .frame(height: 48)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
            }
            
            // Dropdown options with scroll
            if isPickerPresented {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(options, id: \.self) { option in
                            Button(action: {
                                text = option
                                withAnimation {
                                    isPickerPresented = false
                                }
                            }) {
                                HStack {
                                    Text(option)
                                        .font(.custom("Outfit-Medium", size: 14))
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(
                                    option == text
                                    ? Color(hex: "#258694")
                                    : Color.white
                                )
                            }
                            
                            if option != options.last {
                                Divider()
                            }
                        }
                    }
                }
                .frame(maxHeight: 220) // 👈 Limit height so scroll appears
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
            }
        }
    }
}
