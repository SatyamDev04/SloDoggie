//
//  AddParticipantsViewModal.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import SwiftUI

class AddParticipantsViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var allParticipants: [AddParticipant] = [
        AddParticipant(name: "Lydia Vaccaro", imageName: "People1"),
        AddParticipant(name: "Cristofer Siphon", imageName: "People2"),
        AddParticipant(name: "Gretchen Carder", imageName: "People3"),
        AddParticipant(name: "Madelyn Frand", imageName: "People4"),
        AddParticipant(name: "Marilyn Press", imageName: "People5"),
    ]
    
    @Published var selectedParticipants: [AddParticipant] = []

    var filteredParticipants: [AddParticipant] {
        if searchText.isEmpty {
            return allParticipants
        } else {
            return allParticipants.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
    func toggleParticipant(_ participant: AddParticipant) {
        if let index = selectedParticipants.firstIndex(of: participant) {
            selectedParticipants.remove(at: index)
        } else {
            selectedParticipants.append(participant)
        }
    }
    
    func removeParticipant(_ participant: AddParticipant) {
        selectedParticipants.removeAll { $0 == participant }
    }
}
