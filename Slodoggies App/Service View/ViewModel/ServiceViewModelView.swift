//
//  ServiceViewModelView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 24/07/25.
//

import Foundation

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
