//
//  Group&EventViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import Foundation
import UIKit
import PhotosUI
import _PhotosUI_SwiftUI
import Combine
import SwiftUI

enum PostTab {
    case post, event, ads
    
    var title: String {
        switch self {
        case .post: return "New Post"
        case .event: return "New Event"
        case .ads: return "New Promotion"
        }
    }

    var tabLabel: String {
        switch self {
        case .post: return "Post"
        case .event: return "Event"
        case .ads: return "Ads"
        }
    }
}

class CreatePostViewModel: ObservableObject {
    @Published var selectedTab: PostTab = .post
//    @Published var selectedImages: [UIImage] = []
    @Published var selectedMedia: [MediaTypes] = []
    @Published var showImagePicker = false
    @Published var pickerItems: [PhotosPickerItem] = []

    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    @Published var petsArr: [PetsDetailData] = []
    
    @Published var address = ""

    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""

    @Published var latitude: Double?
    @Published var longitude: Double?
    
    // Post And Event Data which goes in API
    @Published var postData : PostData?
    @Published var eventData : eventData?
//    @Published var adsData : adsDataModel?
    @Published var serviceList: [String] = []
//    @Published var selectedTab: BusiPostTab = .ads
//    @Published var selectedMedia: [MediaTypes] = []
//    @Published var showImagePicker = false
//    @Published var pickerItems: [PhotosPickerItem] = []
    
    @MainActor
    func addMedia(from items: [PhotosPickerItem]) async {
        var newMedia: [MediaTypes] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self) {
                if let image = UIImage(data: data) {
                    let newMediaItem = MediaTypes(image: image)   // ← CORRECT for images
                    if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                        newMedia.append(newMediaItem)
                    }
                    continue
                }

                // ... Same for videos
                let tempDir = FileManager.default.temporaryDirectory
                let filename = UUID().uuidString + ".mov"
                let tempURL = tempDir.appendingPathComponent(filename)
                do {
                    try data.write(to: tempURL, options: .atomic)
                    let asset = AVAsset(url: tempURL)
                    if !asset.tracks(withMediaType: .video).isEmpty {
                        let newMediaItem = MediaTypes(videoURL: tempURL) // Hash used here!
                        if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                            newMedia.append(newMediaItem)
                        }
                        continue
                    
                    } else {
                        try? FileManager.default.removeItem(at: tempURL)
                    }
                } catch {
                    print("Failed to write temp video: \(error)")
                }
            }
            // ... Fallback for URL
            if let url = try? await item.loadTransferable(type: URL.self) {
                let tempDir = FileManager.default.temporaryDirectory
                let dest = tempDir.appendingPathComponent(UUID().uuidString + url.lastPathComponent)
                do {
                    try FileManager.default.copyItem(at: url, to: dest)
                    let asset = AVAsset(url: dest)
                    if !asset.tracks(withMediaType: .video).isEmpty {
                        let newMediaItem = MediaTypes(videoURL: dest)
                        if !selectedMedia.contains(newMediaItem) && !newMedia.contains(newMediaItem) {
                            newMedia.append(newMediaItem)
                        }
                    } else {
                        try? FileManager.default.removeItem(at: dest)
                    }
                } catch {
                    print("Failed to copy picker URL: \(error)")
                }
            }
        }
        // Merge + remove duplicates
        let combined = (selectedMedia + newMedia).uniqued()
        selectedMedia = Array(combined.prefix(6))
       // pickerItems.removeAll()
    }


    // MARK: - Remove media
    func removeMedia(at index: Int) {
        guard selectedMedia.indices.contains(index) else { return }
        selectedMedia.remove(at: index)
        pickerItems.removeAll()
    }
    
    func fillAddress(_ place: GooglePlaceDetail) {

        // Save lat + lng
        let latitude = place.geometry?.location.lat ?? 0.0
        let longitude = place.geometry?.location.lng ?? 0.0
        
        print("LAT: \(latitude)")
        print("LNG: \(longitude)")

        self.latitude = latitude
        self.longitude = longitude
        
        var streetName = ""
        var streetNumber = ""
        var city = ""
        var state = ""
        var zip = ""
        print(place.addressComponents, "place Compo")
        // Extract address components
        for component in place.addressComponents {
            let type = component.types.first ?? ""

            switch type {
            case "locality":
                city = component.longName

            case "administrative_area_level_1":
                state = component.shortName ?? component.longName

            case "postal_code":
                zip = component.longName

            case "route":
                streetName = component.longName

            case "street_number":
                streetNumber = component.longName

            default:
                break
            }
        }

        // Build street address properly
        let streetAddress: String
        if !streetNumber.isEmpty && !streetName.isEmpty {
            streetAddress = "\(streetNumber) \(streetName)"
        } else if !streetName.isEmpty {
            streetAddress = streetName
        } else {
            streetAddress = ""
        }
        
        // Final format: "Place Name, 123 Main Street"
        if let placeName = place.name, !placeName.isEmpty {
            if !streetAddress.isEmpty {
                self.address = "\(placeName), \(streetAddress)"
            } else {
                self.address = placeName
            }
        } else {
            self.address = streetAddress
        }

        // Save these too (optional)
        self.city = city
        self.state = state
        self.zipCode = zip
    }
    
    func createPostApi(completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        
        if postData?.petId == "0"{
            postData?.petId = ""
        }
        print("PostData",postData)
        
        APIManager.shared.CreatePost(petID: postData?.petId ?? "",imgs: postData?.media ?? [],postTitle: postData?.postTitle ?? "", hashTags: postData?.hashtag ?? "", address: postData?.address ?? "",lat: postData?.latitude ?? "",long: postData?.longitude ?? "",userType: UserDefaults.standard.string(forKey: "userType") ?? "")
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                if response.success  ?? false {
                    self.selectedMedia.removeAll()
                    self.pickerItems.removeAll()
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
            }.store(in: &cancellables)
      }
    
    func getPetListApi() {
        self.showActivity = true
        APIManager.shared.getPetListApi()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to get business detail with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.petsArr = response.data ?? []
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }.store(in: &cancellables)
    }
    
    func createEventApi(completion: @escaping (Bool) -> Void) {
        
        self.showActivity = true
        
        let startDateTime = convertDateTime(from: eventData?.startDateTime ?? "")
        let endDataTime = convertDateTime(from: eventData?.endDateTime ?? "")
        print("START RAW", eventData?.startDateTime ?? "nil")
        print("END RAW", eventData?.endDateTime ?? "nil")
        
        APIManager.shared.CreateEvent(event_title: eventData?.eventTitle ?? "", event_description: eventData?.eventDesc ?? "", imgs: eventData?.media ?? [], event_start_date: startDateTime?.date ?? "", event_start_time: startDateTime?.time ?? "", event_end_date: endDataTime?.date ?? "", event_end_time: endDataTime?.time ?? "", event_duration: "", address: address, city: city, state: state, zip_code: zipCode, user_type: UserDefaults.standard.string(forKey: "userType") ?? "", latitude: "\(latitude ?? 0.0)", longitude: "\(longitude ?? 0.0)")
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to create event with error: \(error.localizedDescription)")
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

    func convertDateTime(from input: String) -> (date: String, time: String)? {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "MMM dd, yyyy 'at' h:mm a"  // Correct format

        // Replace narrow no-break space U+202F with normal space, to avoid parsing failure
        let cleanedInput = input.replacingOccurrences(of: "\u{202F}", with: " ")

        guard let date = inputFormatter.date(from: cleanedInput) else {
            print("❌ Invalid Date Format:", cleanedInput)
            return nil
        }

        // API required formats
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"

        return (dateFormatter.string(from: date),
                timeFormatter.string(from: date))
    }
    
    func GetServiceList() {
        self.showActivity = true
        
        APIManager.shared.GetService()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                if response.success  ?? false {
//                    self.serviceList = response.data ?? []
                    self.serviceList = response.data?.compactMap { $0.serviceName } ?? []

                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
            }.store(in: &cancellables)
      }
    
 }
