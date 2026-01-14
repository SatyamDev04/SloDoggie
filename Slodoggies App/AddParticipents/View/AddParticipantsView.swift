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
                    .font(.custom("Outfit-Medium", size: 20))
                    .foregroundColor(.black)
                Spacer()
                
                Button(action: {
                    dismiss()
                }) {
                    Image("RightCheckMark")
                        .font(.title2)
                }
            }
            .padding(.horizontal)

            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            
            // Search bar
            HStack{
                Image("Search")
                    .padding(.leading, 4)
                    .frame(width: 15, height: 15)
                TextField("Enter Name", text: $viewModel.searchText)
                    .padding(.leading, 10)
            }
           
            .frame(height: 50)
            .padding(.horizontal)
            .background(Color(hex: "#F4F4F4"))
            .cornerRadius(8)
            .padding(.leading)
            .padding(.trailing)
            
          
            // Selected participants horizontal list
            if !viewModel.selectedParticipants.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.selectedParticipants) { participant in
                            VStack {
                                ZStack(alignment: .topTrailing) {
                                    Image(participant.imageName)
                                        .resizable()
                                        .frame(width: 50, height: 50)
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
                    .padding(.top)
                    .padding(.horizontal)
                 }
              }
           
            // Suggested label
            HStack {
                Text("Suggested")
                    .font(.custom("Outfit-Medium", size: 16))
                    .padding(.top)
                
                Divider()
                    .frame(height: 1)
                    .background(Color(hex: "#258694"))
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                Spacer()
                   
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
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
                        
//                    if viewModel.selectedParticipants.contains(participant) {
//                            Image("tickIcon")
//                                .foregroundColor(.green)
//                        }
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
