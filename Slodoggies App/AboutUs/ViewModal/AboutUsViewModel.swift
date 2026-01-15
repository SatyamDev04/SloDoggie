//
//  AboutUsViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 20/11/25.
//


import Foundation
import Combine

class AboutUsViewModel: ObservableObject {

    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var aboutUsText: String = ""
    
    func getAboutUsdata() {
        self.showActivity = true
        APIManager.shared.getAboutUs()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.aboutUsText = response.data?.content ?? ""
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
 }
