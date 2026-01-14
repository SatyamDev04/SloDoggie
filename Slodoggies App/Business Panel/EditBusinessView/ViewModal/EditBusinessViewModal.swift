//
//  EditBusinessViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 02/09/25.
//

import SwiftUI
import Combine
import PhotosUI
import GooglePlaces
@MainActor
class EditBusinessViewModal: ObservableObject {
    

    // MARK: - Business Info
    @Published var businessName = ""
    @Published var providerName = ""
    @Published var email = ""
    @Published var location = ""
    @Published var website = ""
    @Published var contactNumber = ""
    
    @Published var apiProfileURL: String = ""
    
    @Published var businessAddress = ""

    @Published var city = ""
    @Published var state = ""
    @Published var zipCode = ""

    @Published var latitude: Double?
    @Published var longitude: Double?

    // MARK: - Categories
    @Published var categories: [String] = []
    @Published var newCategory = ""

    // MARK: - Availability
    @Published var availableDays = ""
    @Published var fromTime = Date()
    @Published var toTime = Date()
    @Published var showDaysSelection = false

    // MARK: - Logo Images
    @Published var logoPickerItems: [PhotosPickerItem] = []
    @Published var selectedLogoImages: [UIImage] = []

    // MARK: - Verification Docs
    @Published var docPickerItems: [PhotosPickerItem] = []
    
    @Published var verificationDocs: [VerificationDoc] = []
   // @Published var selectedDocImages: [UIImage] = []

    @Published var businessDetails :  BusiUser??
    @Published var imgData: Data = Data()
    @Published var errorMessage: String? = nil
    @Published var showError: Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var OTP: Int? = nil
    @Published var isPhoneVerified: Bool = false
    @Published var isEmailVerified: Bool = false
    @Published var isPhoneValid: Bool = false
    @Published var isEmailValid: Bool = false
    
   
    // MARK: - Helpers
    func isValidPhone(_ phone: String) -> Bool {
        let regex = #"^[0-9]{10}$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: phone)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let regex = #"^\S+@\S+\.\S+$"#
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: email)
    }
    
    // MARK: - Add Category
    func addCategory() {
        guard !newCategory.isEmpty else { return }
        categories.append(newCategory)
        newCategory = ""
    }

    func removeCategory(_ category: String) {
        categories.removeAll { $0 == category }
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

        // ⭐ Build street address properly
        let streetAddress: String
        if !streetNumber.isEmpty && !streetName.isEmpty {
            streetAddress = "\(streetNumber) \(streetName)"
        } else if !streetName.isEmpty {
            streetAddress = streetName
        } else {
            streetAddress = ""
        }
        
        // ⭐ Final format: "Place Name, 123 Main Street"
        if let placeName = place.name, !placeName.isEmpty {
            if !streetAddress.isEmpty {
                self.businessAddress = "\(placeName), \(streetAddress)"
            } else {
                self.businessAddress = placeName
            }
        } else {
            self.businessAddress = streetAddress
        }

        // Save these too (optional)
        self.city = city
        self.state = state
        self.zipCode = zip
    }

    // MARK: - Image Handling
    
    func loadLogoImages() async {
        guard let item = logoPickerItems.first else { return }

        // Reset old data
        selectedLogoImages.removeAll()
        imgData = Data()
        apiProfileURL = ""   // remove API image when user selects new one

        if let data = try? await item.loadTransferable(type: Data.self),
           let uiImage = UIImage(data: data) {

            selectedLogoImages = [uiImage]
            imgData = uiImage.jpegData(compressionQuality: 0.8) ?? Data()
        }

        // Reset picker so user can reselect same image again
        logoPickerItems.removeAll()
    }

    
//    func loadLogoImages() async {
//        for item in logoPickerItems {
//        if let data = try? await item.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//            selectedLogoImages.append(uiImage)
//            imgData = uiImage.jpegData(compressionQuality: 0.8) ?? Data()
//            print(imgData, "It's imgData")
//            }
//        }
//    }

//    func loadDocImages() async {
//        for item in docPickerItems {
//            if let data = try? await item.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//                selectedDocImages.append(uiImage)
//            }
//        }
//    }
    
//    func loadDocImages() async {
//        for item in docPickerItems {
//            if let data = try? await item.loadTransferable(type: Data.self),
//               let uiImage = UIImage(data: data) {
//
//                verificationDocs.append(.new(image: uiImage))
//            }
//        }
//    }
    
    func loadDocImages() async {
        for item in docPickerItems {

            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {

                // Prevent duplicate images
                let exists = verificationDocs.contains {
                    if case .new(let image) = $0 {
                        return image.pngData() == uiImage.pngData()
                    }
                    return false
                }

                if !exists {
                    verificationDocs.append(.new(image: uiImage))
                }
            }
        }

        // Reset picker
        docPickerItems.removeAll()
    }


    func removeLogo(at index: Int) {
        selectedLogoImages.remove(at: index)
        imgData = Data()
    }

    func removeDoc(at index: Int) {
        verificationDocs.remove(at: index)
    }

    func removeVerificationDoc(_ doc: VerificationDoc) {
        verificationDocs.removeAll { $0.id == doc.id }
    }
 
    // MARK: - Validation
    func validate() -> String? {
        if businessName.isEmpty { return "Enter business name" }
        if email.isEmpty { return "Enter email" }
        if contactNumber.isEmpty { return "Enter contact number" }
        if businessAddress.isEmpty { return "Enter business address" }
        if city.isEmpty { return "Enter city" }
        if state.isEmpty { return "Enter state" }
        if zipCode.isEmpty { return "Enter zip code" }

        return nil
    }
    
    func getYourBusinessDetailApi() {
        self.showActivity = true
        APIManager.shared.getBussinessProfile(userID: UserDetail.shared.getUserId())
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to get business detail with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.businessDetails = response.data
                    
                    self.businessName = response.data?.businessName ?? ""
                    self.businessAddress = response.data?.address ?? ""
                    self.state = response.data?.state ?? ""
                    self.city = response.data?.city ?? ""
                    self.zipCode = response.data?.zipCode ?? ""
                    self.latitude = Double(response.data?.latitude ?? "")
                    self.longitude = Double(response.data?.longitude ?? "")
                    self.providerName = response.data?.providerName ?? ""
                    self.contactNumber = response.data?.phone ?? ""
                    self.email = response.data?.email ?? ""
                    self.website = response.data?.websiteURL ?? ""
                    self.apiProfileURL = response.data?.businessLogo ?? ""
                    self.categories = response.data?.category ?? []
                    let daysString = response.data?.availableDays?.joined(separator: ", ") ?? ""
                    let timeRange = response.data?.availableTime ?? ""
                    let parts = timeRange.split(separator: "-")

                    let fromTime = String(parts.first ?? "")
                    let toTime   = String(parts.last ?? "")

                    print("From:", fromTime)
                    print("To:", toTime)
                    if let fromDate = self.timeStringToDate(fromTime),
                       let toDate = self.timeStringToDate(toTime) {

                        self.availableDays =
                        "\(daysString) (\(self.formatDate(fromDate)) - \(self.formatDate(toDate)))"
                    }
//                    self.availableDays = "\(daysString) (\(formatDate(fromTime)) - \(formatDate(toTime)))"
                    self.verificationDocs =
                        response.data?.verificationDocs?
                            .map { VerificationDoc.existing(url: $0) } ?? []

                    if let phone = response.data?.phone, !phone.isEmpty {
                        self.isPhoneVerified = true
                    }
                    
                    if let email = response.data?.email, !email.isEmpty {
                        self.isEmailVerified = true
                    }
                    
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
    
    func timeStringToDate(_ time: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: time)
    }

    func AddYourBusinessApi(completion: @escaping (Bool) -> Void) {
        self.showActivity = true
//        let input = "Sunday, Wednesday (11:00 AM - 08:00 PM)"
        let result = parseSchedule(self.availableDays)
        let catString = arrayToCommaString(self.categories)
        print(result.days, "Days")
        print(result.time, "Time")
        print(catString, "Cat")
        
        let newImages: [UIImage] = verificationDocs.compactMap {
            if case .new(let image) = $0 {
                return image
            }
            return nil
        }
        
        APIManager.shared.AddBusinessApi(providerName:self.providerName, business_name: self.businessName, email: self.email, phone: self.contactNumber, LogoImg: ["business_logo": imgData], business_category: catString, business_address: self.businessAddress, city: self.city, state: self.state, zip_code: self.zipCode, latitude: "\(self.latitude ?? 0.0)", longitude: "\(self.longitude ?? 0.0)", website_url: self.website, available_days: result.days, available_time: result.time, verification_docs: newImages)
            .sink { completionn in
                self.showActivity = false
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
    
    
    func sendOtp(Email_phone:String, completion: @escaping (Bool) -> Void) {
        self.showActivity = true
        APIManager.shared.sendOtp(email_Phone: Email_phone, apiType: "signup")
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
                    self.OTP = response.data?.otp
                    completion(true)
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                    completion(false)
                }
                
            }.store(in: &cancellables)
        
    }
    
    func parseSchedule(_ input: String) -> (days: String, time: String) {
        
        // 1. Extract days (before "(" )
        let daysPart = input.components(separatedBy: "(").first?
            .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let daysArray = daysPart
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        // Convert array → comma-separated string
        let daysString = daysArray.joined(separator: ",")
        
        // 2. Extract time inside parentheses
        var timeResult = ""
        
        if let start = input.firstIndex(of: "("),
           let end = input.firstIndex(of: ")") {
            
            let rawTime = input[input.index(after: start)..<end]
            
            // Remove ALL spaces → "11:00AM-08:00PM"
            timeResult = rawTime.replacingOccurrences(of: " ", with: "")
        }
        
        return (daysString, timeResult)
    }

    func arrayToCommaString(_ array: [String]) -> String {
        return array.joined(separator: ",")
    }
    
    
}


enum VerificationDoc: Identifiable, Hashable {
    case existing(url: String)
    case new(image: UIImage)

    var id: String {
        switch self {
        case .existing(let url):
            return url
        case .new(let image):
            return "\(image.hashValue)"
        }
    }
}
