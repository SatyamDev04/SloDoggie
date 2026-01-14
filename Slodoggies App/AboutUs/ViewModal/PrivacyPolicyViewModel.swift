//
//  PrivacyPolicyViewModel.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 20/11/25.
//

import Foundation
import Combine

class PrivacyPolicyViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var privacyPolicyText: String = ""
    
    func getPrivacyPolicy() {
        self.showActivity = true
        APIManager.shared.getPrivacyPolicy()
            .sink { completionn in
                self.showActivity = false
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.privacyPolicyText = response.data?.content?.htmlStripped() ?? ""
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
}
