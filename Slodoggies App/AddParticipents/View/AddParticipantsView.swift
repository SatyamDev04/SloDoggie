//
//  AddParticipantsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import SwiftUI

struct AddParticipantsView: View {
    @StateObject private var viewModel = AddParticipantsViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Button(action: { dismiss() }) {
                    Image("Back")
                        .font(.title2)
                }
               
                Text("Add Participants")
                    .font(.headline)
                Spacer()
                Button(action: {
                    // Done tapped
                }) {
                    Image("RightCheckMark")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            // Search bar
            HStack{
                Image("Search")
                TextField("Enter Name", text: $viewModel.searchText)
                    .cornerRadius(8)
                    .padding(.horizontal)
                
            }
            .background(Color(.systemGray6))
            .padding(10)

            Spacer()
            // Selected participants horizontal list
            if !viewModel.selectedParticipants.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.selectedParticipants) { participant in
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    Image(participant.imageName)
                                        .resizable()
                                        .frame(width: 60, height: 60)
                                        .clipShape(Circle())
                                    
                                    Spacer()
                                    Button(action: {
                                        viewModel.removeParticipant(participant)
                                    }) {
                                        Image("RedCancel")
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 6, y: -2)
                                }
                                Text(participant.name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
            // Suggested label
            HStack {
                Text("Suggested")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding(.horizontal)

            // Suggested participants list
            List {
                ForEach(viewModel.filteredParticipants) { participant in
                    HStack {
                        Image(participant.imageName)
                            .resizable()
                            .frame(width: 45, height: 45)
                            .clipShape(Circle())
                        
                        Text(participant.name)
                        Spacer()
                        
                        if viewModel.selectedParticipants.contains(participant) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.toggleParticipant(participant)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .padding(.top)
    }
 }

  #Preview {
     AddParticipantsView()
  }
