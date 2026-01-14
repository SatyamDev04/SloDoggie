//
//  BusiAddServiceViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 01/09/25.
//

import Foundation
import SwiftUI
import PhotosUI
import Combine
import SDWebImage

class AddServiceViewModel: ObservableObject {
    
    @Published var businessServiceResponse: BusinessServiceModel?
    
    // MARK: - Form Fields
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var price: String = ""
    
    // MARK: - Media Picker
    @Published var images: [ServiceImage] = []   // ✅ SINGLE SOURCE
    @Published var pickerItems: [PhotosPickerItem] = []
    @Published var selectedImages: [UIImage] = []
   
    @Published private(set) var selectedImageHashes: Set<String> = []
    
    // MARK: - Edit Mode Support
    @Published var serviceId: String? = nil
    @Published var existingImagesURL: [String] = []   // URLs from server in edit mode
    
    // MARK: - Loading & Alerts
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    @Published var showError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    

    // MARK: - Validation
    private func validateFields() -> Bool {
        if title.isEmpty {
            errorMessage = "Please enter service title"
            showError = true
            return false
        }
        if description.isEmpty {
            errorMessage = "Please enter description"
            showError = true
            return false
        }
        if price.isEmpty {
            errorMessage = "Please enter price"
            showError = true
            return false
        }
        return true
    }
    
    
    // MARK: - Remove image
    
    func removeImage(at index: Int) {
        guard images.indices.contains(index) else { return }

        let removed = images[index]
        images.remove(at: index)

        if case .local(let id, _) = removed {
            selectedImageHashes.remove(id)
        }
    }
    
    func resetForm() {
        title = ""
        description = ""
        price = ""
        images.removeAll()
        pickerItems.removeAll()
    }


    @MainActor
    func loadPickerImages(_ items: [PhotosPickerItem]) async {

        let remoteImages = images.filter {
            if case .remote = $0 { return true }
            return false
        }
        print(remoteImages.count,"yahi hai")
        var existingLocalImages = images.filter {
            if case .local = $0 { return true }
            return false
        }

        var newLocalImages: [ServiceImage] = []

        for item in items {

            guard
                let data = try? await item.loadTransferable(type: Data.self),
                let uiImage = UIImage(data: data)
            else { continue }

            let hash = imageHash(from: data)

            //  ABSOLUTE DUPLICATE BLOCK
            guard !selectedImageHashes.contains(hash) else { continue }

            selectedImageHashes.insert(hash)
            newLocalImages.append(
                .local(id: hash, image: uiImage)
            )
        }

        images = remoteImages + existingLocalImages + newLocalImages
    }


    // MARK: - Set API images (edit mode)
    func setRemoteImages(_ urls: [String]) {
        
        for (index, urlString) in urls.enumerated() {
            guard let url = URL(string: urlString) else { continue }
            
            SDWebImageManager.shared.loadImage(
                with: url,
                options: [.highPriority],
                progress: nil
            ) { [weak self] image, _, error, _, _, _ in
                guard
                    let self = self,
                    let image = image,
                    error == nil
                else { return }
                
                DispatchQueue.main.async {
                    self.images.append(.remote(url: urlString, image: image))
                }
            }
        }
    
        //images = urls.map { .remote(url: $0, image: nil) }
    }
    
    // MARK: - Add Service API
    func addService() {
        guard validateFields() else { return }
        isLoading = true
        
        let imageDataArray = images.compactMap {
            if case .local(_, let image) = $0 {
                return image.jpegData(compressionQuality: 0.7)
            }
            return nil
        }
        // ---- MOCK API ---- Replace with real API --------
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isLoading = false
            self.successMessage = "service_added"
            print("Service Added Successfully")
        }
    }
    
    // MARK: - Edit Service API

//    func updateService() {
//        guard validateFields() else { return }
//        guard serviceId != nil else { return }
//
//        isLoading = true
//
//        let imageDataArray = images.compactMap {
//            if case .local(_, let image) = $0 {
//                return image.jpegData(compressionQuality: 0.7)
//            }
//            return nil
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.isLoading = false
//            self.successMessage = "service_updated"
//        }
//    }

    
    func AddYourBusinessApi(completion: @escaping (Bool) -> Void) {
        guard validateFields() else { return }
        var localImages: [UIImage] = []
        for image in images {
            switch image {
               
            case .local(id: let id, image: let image):
                localImages.append(image)
            case .remote(url: let url, image: let image):
                localImages.append(image ?? UIImage())
            }
        }
    
        self.isLoading = true
        
        APIManager.shared.AddServiceApi(service_name: self.title, desc: self.description, price: self.price, imgs: localImages, serviceId: self.serviceId ?? "")
            .sink { completionn in
                self.isLoading = false
                if case .failure(let error) = completionn {
                    print("Failed to register business with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
            }.store(in: &cancellables)
    }
    
    
    
    
    func getBusinessServiceDetails() {
        self.isLoading = true
        APIManager.shared.getBussinessServiceDetails(businessID: 0)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.businessServiceResponse = response.data
                    print(self.businessServiceResponse, "getBusinessServiceDetails")
               
                } else {
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }
            .store(in: &cancellables)
    }
    
    enum ServiceImage: Identifiable, Equatable {
        case remote(url: String, image: UIImage?)
        case local(id: String, image: UIImage)

        var id: String {
            switch self {
            case .remote(let url, _):
                return url
            case .local(let id, _):
                return id
            }
        }
    }
}

private func imageHash(from data: Data) -> String {
    data.base64EncodedString()
}
