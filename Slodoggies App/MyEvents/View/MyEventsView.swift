//
//  MyEventsView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI

struct EventListView: View {
    @StateObject private var viewModel = EventListViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State private var selectedEvent: Event? = nil
    private let tabs = ["My Events", "Saved"]

    var body: some View {
        VStack {
            HStack(spacing: 20){
                Button(action: {
                    coordinator.pop()
                }){
                    Image("Back")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                Text("My Events")
                    .font(.custom("Outfit-Medium", size: 22))
                    .foregroundColor(Color(hex: " #221B22"))
                //.padding(.leading, 100)
            }
            .padding(.leading, -180)
            .padding(.horizontal,25)
            //.padding(.bottom,2)
            
            Divider()
                .frame(height: 2)
                .background(Color(hex: "#258694"))
            // Tabs
            HStack {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        viewModel.selectTab(tab)
                    }) {
                        Text(tab)
                            .font(.custom("Outfit-Regular", size: 14))
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .background(viewModel.selectedTab == tab ? Color(hex: "#258694") : Color.clear)
                            .foregroundColor(viewModel.selectedTab == tab ? .white : .black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Event List
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.events) { event in
                        EventCardView(event: event) {
                            coordinator.push(.EventParticipants) // 👈 Navigate here
                        }
                    }
                }
                .padding()
            }
         }
      }
   }

  #Preview {
      EventListView()
  }
