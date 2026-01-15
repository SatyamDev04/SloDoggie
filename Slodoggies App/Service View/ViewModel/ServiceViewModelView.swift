//
//  ServiceViewModelView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import Foundation
import SwiftUI
import Combine

class ServicesListViewModel: ObservableObject {
    @Published var allProviders: [Provider] = [
        Provider(servieName: "Pawfect Pet Care", provideName: "ProviderName", rating: 4.8, serviceType: "Grooming", iconName: "DogFootIcon"),
        Provider(servieName: "SLO Pet Centre", provideName: "ProviderName", rating: 4.8, serviceType: "Walking", iconName: "DogFootIcon"),
        Provider(servieName: "Pawfect Pet Care", provideName: "ProviderName", rating: 4.8, serviceType: "Grooming", iconName: "DogFootIcon"),
        Provider(servieName: "SLO Pet Centre", provideName: "ProviderName", rating: 4.8, serviceType: "Walking", iconName: "DogFootIcon"),
        // Add more
    ]
    
    @Published var selectedFilter: String? = nil
    
    var filteredProviders: [Provider] {
        if let filter = selectedFilter {
            return allProviders.filter { $0.serviceType == filter }
        }
        return allProviders
    }
    
    let filters = ["Walking", "Grooming", "Sitting / Boarding", "Veterinary"]
 }



//MARK:- Service Filter Chips Api ViewModel
import Combine

final class ServiceFilterChipViewModel: ObservableObject {

    @Published var categories: [Category] = []
    @Published var serviceProviders: [ServiceItem] = []
    @Published var selectedCategory: String?
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Filtered Providers
    var filteredServiceProviders: [ServiceItem] {

            serviceProviders.filter { provider in

                // Category filter
                let matchesCategory: Bool = {
                    guard let selected = selectedCategory else { return true }
                    return provider.categoryName?
                        .compactMap { $0 }
                        .contains(selected) == true
                }()

                // Search filter (service + provider name)
                let matchesSearch: Bool = {
                    guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else {
                        return true
                    }

                    let search = searchText.lowercased()

                    return provider.serviceName?.lowercased().contains(search) == true ||
                           provider.providerName?.lowercased().contains(search) == true
                }()

                return matchesCategory && matchesSearch
            }
        }

    // MARK: - Fetch Categories
    func fetchCategories() {
        isLoading = true
        APIManager.shared.getCategoryResponse()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.categories = response.data ?? []
            }
            .store(in: &cancellables)
    }

    // MARK: - Fetch Providers
    func fetchProviders() {
        isLoading = true
        APIManager.shared.getServiceProvider(id: UserDetail.shared.getUserId(), search: "")
            .receive(on: DispatchQueue.main)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.serviceProviders = response.data ?? []
            }
            .store(in: &cancellables)
    }
}
