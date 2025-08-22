//
//  ServiceFilterChip.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Outfit-Regular", size: 14))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .frame(height: 42)
                .frame(maxWidth: .infinity)
                .background(
                    isSelected ? Color(hex: "#258694") : Color.clear
                )
                .foregroundColor(
                    isSelected ? .white : Color(hex: "#949494")
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isSelected ? Color(hex: "#258694") : Color(hex: "#949494"),
                            lineWidth: 1
                        )
                )
                .cornerRadius(10)
        }
    }
}

struct FilterChipListView: View {
    let options = ["Option 1", "Option 2", "Option 3"]
    
    @State private var selectedOption: String
    
    init() {
        _selectedOption = State(initialValue: options.first ?? "")
    }
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                FilterChip(
                    title: option,
                    isSelected: selectedOption == option,
                    action: {
                        selectedOption = option
                    }
                )
            }
        }
        .padding()
    }
}
