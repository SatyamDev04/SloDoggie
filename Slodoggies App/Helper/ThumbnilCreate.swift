//
//  ThumbnilCreate.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 26/11/25.
//

import Foundation
import AVFoundation
import SwiftUI

func generateThumbnail(from url: URL) -> UIImage? {
    let asset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)
    imageGenerator.appliesPreferredTrackTransform = true
    
    let time = CMTime(seconds: 1, preferredTimescale: 60)

    do {
        let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
        return UIImage(cgImage: cgImage)
    } catch {
        print("❌ Error generating thumbnail:", error)
        return nil
    }
}
