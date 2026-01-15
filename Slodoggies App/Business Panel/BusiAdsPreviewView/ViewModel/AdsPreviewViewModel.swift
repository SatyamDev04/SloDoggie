//
//  AdsPreviewViewModel.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/09/25.
//

import Foundation
import Combine

class AdsPreviewViewModel: ObservableObject {
//    @Published var ad: AdsPreviewModel
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
//    init() {
//        // Mock data for now
//        self.ad = AdsPreviewModel(
//            title: "Free First Walk",
//            description: "Get your pet’s first walk for free with Happy Paws!",
//            category: "Grooming",
//            service: "Service name 1",
//            expiryDate: Date(timeIntervalSinceNow: 86400 * 20), // 20 days later
//            terms: "Offer valid for new customers only.",
//            location: "Local (San Luis Obispo)",
//            contactInfoDisplay: true,
//            mobileNumber: "805 123-4567",
//            dailyBudget: 42,
//            adBudget: 42
//        )
//    }
    
//    var formattedExpiry: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy - hh:mm a"
//        return formatter.string(from: ad.expiryDate)
//    }
    
    func createAddApi(adsData:adsDataModel, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        
        var updatedAdsData = adsData

        let expDateTime = convertDateTime(from: adsData.expiryDate ?? "")
        updatedAdsData.expiryDate = expDateTime?.date
        updatedAdsData.expiryTime = expDateTime?.time
        
        APIManager.shared.CreateAds(adsData: updatedAdsData)
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    completion(false)
                }
            } receiveValue: { response in
                if response.success  ?? false {
//                    self.selectedMedia.removeAll()
//                    self.pickerItems.removeAll()
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
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"

        guard let date = inputFormatter.date(from: input) else {
            print("❌ Invalid Date Format:", input)
            return nil
        }

        // API required formats
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"

        return (
            dateFormatter.string(from: date),
            timeFormatter.string(from: date)
        )
    }

    
}
