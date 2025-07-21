//
//  EventCommunityView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 16/07/25.
//

import SwiftUI

struct EventParticipantsView: View {
    @StateObject private var viewModel = EventParticipantsViewModel()
    @State private var isRenameSheetPresented = false
    @State private var isEditParticipantsPresented = false
    @State private var selectedParticipantID: UUID? = nil
    @EnvironmentObject private var coordinator: Coordinator
    @State private var isRemoveUserPopupPresented = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Top Nav
            HStack {
                Button(action: {
                    coordinator.pop()
                }) {
                    Image("Back")
                }
                Spacer()
                Button(action: {}) {
                    Image("ShareIcon")
                }
            }
            .padding(.horizontal)

            // Image & Title
            VStack(spacing: 8) {
                Image("EventImage") // Replace with custom icon if needed
                    .resizable()
                    .frame(width: 147, height: 147)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
                HStack(spacing: 4) {
                    Text(viewModel.eventName)
                        .font(.custom("Outfit-Regular", size: 18))
                    Button(action: {
                        isRenameSheetPresented = true
                    }) {
                        Image("PencilIcon")
                    }
                }
            }
            .sheet(isPresented: $isRenameSheetPresented) {
                RenameCommunitySheet(isPresented: $isRenameSheetPresented, currentName: viewModel.eventName) { newName in
                    viewModel.eventName = newName
                }
                .presentationDetents([.height(300)])
                //.presentationDragIndicator(.visible)
            }

            Spacer()
            // Participants List Title
            HStack {
                Text("Participants")
                    .font(.custom("Outfit-Medium", size: 16))
                
                Spacer()
                Button(action: {
                    coordinator.push(.addParticipants)
                }) {
                    Image("AddMember")
                }
            }
            .padding(.horizontal)
            
            Divider()
                .frame(height: 1)
                .background(Color(hex: "#258694"))
                .padding(.leading, 16)
                .padding(.trailing, 16)
            
            // List of Participants
            List {
                ForEach(viewModel.participants) { participant in
                    HStack {
                        Image(participant.imageName)
                            .resizable()
                            .frame(width: 38, height: 38)
                            .clipShape(Circle())
                        Text(participant.name)
                            .font(.custom("Outfit-Regular", size: 15))
                        
                        Spacer()
                        Button(action: {
                            isEditParticipantsPresented = true
                        }) {
                            Image("ThreeDots")
                                .frame(height: 14)
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.vertical, 4)
                    .frame(height: 45)
                }
            }
            .listStyle(.plain)
            
            // Pop-up overlay
            if isRemoveUserPopupPresented {
                RemoveParticipantsPopUpView(isPresented: $isRemoveUserPopupPresented)
                    .transition(.opacity)
                    .zIndex(1)
            }
        }
        .padding(.top)
        
        .sheet(isPresented: $isEditParticipantsPresented) {
            EditParticipantsView(
                isPresented: $isEditParticipantsPresented,
                onRemoveUser: {
                    // Delay showing popup until sheet closes
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        isRemoveUserPopupPresented = true
                    }
                },
                onViewProfile: {
                    // Handle view profile logic
                }
            )
            .presentationDetents([.height(180)])
            .presentationDragIndicator(.visible)
        }
      }
   }

#Preview {
    EventParticipantsView()
}
