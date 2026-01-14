//
//  ImagePopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 09/09/25.

import SwiftUI

struct ImagePopupView: View {
    let photos: [String]
    @Binding var selectedIndex: Int
    var onClose: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {

                               // Centered image using SDWebImage
                               Image.loadImage(
                                   photos[safe: selectedIndex] ?? photos.first ?? "",
                                   width: UIScreen.main.bounds.width - 80,
                                   height: 260,
                                   cornerRadius: 12,
                                   contentMode: .fill
                               )
                               .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 5)
               
            }
            .padding(14)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.18), radius: 20, x: 0, y: 10)

            // Navigation buttons + page control dots
            HStack {
                Button {
                    if selectedIndex > 0 { selectedIndex -= 1 }
                } label: {
                    Image("previousImageIcon")
                        .padding(10)
                }

                Spacer()

                // Page Control Dots
                HStack(spacing: 6) {
                    ForEach(0..<photos.count, id: \.self) { index in
                        Circle()
                            .fill(index == selectedIndex ? Color.white : Color(hex: "#B4B4B4"))
                            .frame(width: index == selectedIndex ? 10 : 8,
                                   height: index == selectedIndex ? 10 : 8)
                            .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                    }
                }

                Spacer()

                Button {
                    if selectedIndex < max(photos.count - 1, 0) { selectedIndex += 1 }
                } label: {
                    Image("nextImageIcon")
                        .padding(10)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 270)

            // Close button (top-right)
            Button(action: onClose) {
                Image("crossIcon")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .padding(8)
                    .clipShape(Circle())
            }
            .padding(.top, -45)
            .padding(.trailing, 10)
        }
    }
}

// Optional safe index helper
extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct ImagePopupView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePopupView(
            photos: ["1", "2", "3"], // replace with real asset names
            selectedIndex: .constant(0),
            onClose: {}
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2))
    }
}
