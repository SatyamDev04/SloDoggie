//
//  HelperFile.swift
//  AWPL
//
//  Created by YATIN  KALRA on 07/05/25.
//

import Foundation
import UIKit
import SwiftUI
//import SDWebImageSwiftUI
struct HTMLText: UIViewRepresentable {
    let html: String

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.attributedText = html.toAttributedString()
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.attributedText = html.toAttributedString()
    }
}


extension String {
    func toAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: .utf16, allowLossyConversion: false) else { return nil }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf16.rawValue
        ]
        return try? NSAttributedString(data: data, options: options, documentAttributes: nil)
    }
}
// MARK: - Extension
extension String {
    func localized(_ bundle: Bundle = .main) -> String {
        NSLocalizedString(self, bundle: bundle, comment: "")
    }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}


extension Image {
//    static func loadImage(
//        _ urlString: String?,
//        width: CGFloat = 160,
//        height: CGFloat = 170,
//        cornerRadius: CGFloat = 0,
//        contentMode: ContentMode = .fill
//    ) -> some View {
//        WebImage(url: URL(string: urlString ?? ""))
//            .resizable()
//            .indicator(.activity)
//            .aspectRatio(contentMode: contentMode)
//            .frame(width: width, height: height)
//            .if(cornerRadius > 0) { $0.cornerRadius(cornerRadius) }
//            .clipped()
//    }
}
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 12.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
extension String {
    /// Returns a plain string with HTML tags removed
    func htmlStripped() -> String {
        guard let data = self.data(using: .utf8) else { return self }
        if let attributed = try? NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html,
                      .characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil
        ) {
            return attributed.string
        }
        return self
    }
}
extension URL {
    func fileSizeString() -> String {
        do {
            let resourceValues = try self.resourceValues(forKeys: [.fileSizeKey])
            if let size = resourceValues.fileSize {
                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useMB]
                formatter.countStyle = .file
                return formatter.string(fromByteCount: Int64(size))
            }
        } catch {
            print(error.localizedDescription)
        }
        return "N/A"
    }
}
