//
//  ViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 15/07/25.
//

import Foundation
import Combine

class TermConditionViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    @Published var showActivity = false
    
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    
    @Published var termConditionText: String = ""
    
    func getTNCdata() {
        self.showActivity = true
        APIManager.shared.getTnc()
            .sink { completionn in
                   
                if case .failure(let error) = completionn {
                    print("Failed to send OTP with error: \(error.localizedDescription)")
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                
                if response.success  ?? false {
                    self.termConditionText = response.data?.content ?? ""
                }else{
                    self.showError = true
                    self.errorMessage = response.message ?? "Something went wrong"
                }
                
            }.store(in: &cancellables)
        
    }
    
}


