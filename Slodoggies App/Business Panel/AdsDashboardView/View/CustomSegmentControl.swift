//
//  CustomSegmentControl.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 27/08/25.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedTab: AdTab
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(AdTab.allCases, id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab.rawValue)
                        .font(.custom("Outfit-Regular", size: 14))
                        .frame(maxWidth: .infinity, minHeight: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    selectedTab == tab ? Color(hex: "#258694") : Color(hex: "#949494"),
                                    lineWidth: 1
                                )
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(selectedTab == tab ? Color.white : Color.clear)
                                )
                        )
                        .foregroundColor(selectedTab == tab ? Color(hex: "#258694") : Color(hex: "#949494"))
                }
            }
        }
        .padding(.horizontal)
    }
}
