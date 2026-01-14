//
//  HelperFile.swift
//  AWPL
//
//  Created by YATIN  KALRA on 07/05/25.
//

import Foundation
import UIKit
import SwiftUI
import SDWebImageSwiftUI
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

extension Optional where Wrapped == String {
    var capitalizedWords: String {
        switch self {
        case "high": return "High"
        case "low": return "Low"
        case "medium": return "Medium"
        case "none": return "None"
        case "daily": return "Daily"
        case "weekly": return "Weekly"
        case "monthly": return "Monthly"
        default: return ""
        }
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension Locale {
    static var currentRegionCode: String {
        return Locale.current.region?.identifier ?? "US" // fallback
    }
}
extension String {
    var flag: String {
        unicodeScalars.reduce("") {
            if let scalar = UnicodeScalar(127397 + $1.value) {
                return $0 + String(scalar)
            }
            return $0
        }
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
    func autoConvertDateFormat(to outputFormat: String) -> String {
        let possibleFormats = [
            // ISO & RFC formats
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXX",
            "yyyy-MM-dd'T'HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",

            // Common international formats
            "yyyy-MM-dd",
            "dd-MM-yyyy",
            "MM-dd-yyyy",
            "dd/MM/yyyy",
            "MM/dd/yyyy",
            "yyyy/MM/dd",
            "dd.MM.yyyy",
            "MM.dd.yyyy",
            "yyyy.MM.dd",
            "d MMM yyyy",
            "dd MMM yyyy",
            "MMM dd, yyyy",
            "MMMM dd, yyyy",
            "EEE, dd MMM yyyy",
            "EEEE, MMM d, yyyy",

            // With time
            "yyyy-MM-dd HH:mm:ss",
            "yyyy/MM/dd HH:mm:ss",
            "dd-MM-yyyy HH:mm:ss",
            "dd/MM/yyyy HH:mm:ss",
            "MM/dd/yyyy HH:mm:ss",
            "yyyy-MM-dd HH:mm",
            "dd-MM-yyyy HH:mm",
            "MM/dd/yyyy hh:mm a",
            "dd MMM yyyy HH:mm:ss",
            "MMM dd, yyyy hh:mm:ss a",
            "MMM dd, yyyy HH:mm:ss",

            // Compact formats
            "yyyyMMdd",
            "ddMMyyyy",
            "MMddyyyy",

            // US-style formats
            "MM-dd-yyyy hh:mm:ss a",
            "MM/dd/yyyy hh:mm:ss a",
            "MMMM d, yyyy",
            "MMMM d, yyyy h:mm:ss a",

            // Time-only (just in case)
            "HH:mm:ss",
            "hh:mm:ss a",
            "HH:mm",
            "hh:mm a"
        ]
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        for format in possibleFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: self) {
                formatter.dateFormat = outputFormat
                return formatter.string(from: date)
            }
        }
        return "" // None matched
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
    static func loadImage(
        _ urlString: String?,
        width: CGFloat = 160,
        height: CGFloat = 170,
        cornerRadius: CGFloat = 0,
        contentMode: ContentMode = .fill
    ) -> some View {
        WebImage(url: URL(string: urlString ?? ""))
            .resizable()
            .indicator(.activity)
            .aspectRatio(contentMode: contentMode)
            .frame(width: width, height: height)
            .if(cornerRadius > 0) { $0.cornerRadius(cornerRadius) }
            .clipped()
    }
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
extension String {
    /// Removes all spaces from the string
    var withoutSpaces: String {
        return self.replacingOccurrences(of: " ", with: "")
    }
    
    /// Removes spaces at start and end only
    var trimmedSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}

extension View {
//    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
//        clipShape(RoundedCorner(radius: radius, corners: corners))
//    }
    
    func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
