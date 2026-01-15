//
//  ImagePickerView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onImgPick: (UIImage) -> Void
    var onLimitExceeded: (String) -> Void   // 👉 callback when >2MB
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                if let compressedImage = selectedImage.compressTo(maxSizeMB: 2) {
                    parent.image = compressedImage
                    parent.onImgPick(compressedImage)
                } else {
                    parent.onLimitExceeded("Image cannot be larger than 2MB")
                }
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}


// MARK: - UIKit Image Picker Wrapper
struct ImagePickers: UIViewControllerRepresentable{
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    init(sourceType: UIImagePickerController.SourceType, selectedImage: Binding<UIImage?>) {
        self.sourceType = sourceType
        self._selectedImage = selectedImage
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickers
        init(_ parent: ImagePickers) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }
    }
}

// MARK: - Compression Helper
extension UIImage {
    func compressTo(maxSizeMB: Double) -> UIImage? {
        let maxBytes = Int(maxSizeMB * 1024 * 1024)
        var compression: CGFloat = 1.0
        guard var data = self.jpegData(compressionQuality: compression) else { return nil }
        
        while data.count > maxBytes && compression > 0.05 {
            compression -= 0.1
            if let newData = self.jpegData(compressionQuality: compression) {
                data = newData
            }
        }
        
        return data.count <= maxBytes ? UIImage(data: data) : nil
    }
}

