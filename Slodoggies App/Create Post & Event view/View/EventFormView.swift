//
//  EventFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import SwiftUI

struct EventFormView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var selectedDuration = ""
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var duration = "30 mins"
    @State private var addAddress = ""
    @State private var useCurrentLocation = false
    @State private var rsvpRequired = true
    @State private var enableComments = true

    let durations = ["30 mins", "1 hour", "2 hours", "Half Day", "Full Day"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            UploadMediaView()

            VStack(alignment: .leading, spacing: 8) {
                Text("Event Title")
                    .font(.headline)
                TextField("Enter Title", text: $title)
                    .padding(.vertical, 12) // increases height inside
                    .padding(.horizontal, 10) // keeps horizontal spacing nice
                    .cornerRadius(8)
                    .frame(height: 50)
                    .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color(red: 198/255, green: 198/255, blue: 201/255), lineWidth: 0.5)
                            )
                            .cornerRadius(8) 
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Event Desription")
                    .font(.headline)

                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
            }

                EventDatePickerField(title: "Event Start Date And Time")
                EventDatePickerField(title: "Event End Date And Time")
                
            }
                       
                       // Event Duration
                       VStack(alignment: .leading, spacing: 6) {
                           Text("Event Duration")
                               .font(.caption)
                               .foregroundColor(.black)
                           
                           HStack {
                               Picker(
                                   "Select Duration",
                                   selection: $selectedDuration
                               ) {
                                   Text("Select Duration").tag("")
                                   ForEach(durations, id: \.self) { duration in
                                       Text(duration)
                                   }
                               }
                               .pickerStyle(.menu)
                               
                               Spacer()
                               
                               Image(systemName: "chevron.down")
                                   .foregroundColor(.gray)
                           }
                           .padding()
                           .overlay(
                               RoundedRectangle(cornerRadius: 8)
                                   .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                           )
                       }
              
            Text("Location")
            Button(action: {}) {
                HStack{
                    Image("mage_location")
                    Text("Use My Current Location")
                        .foregroundColor(.black)
                }
            }
            TextField("Add Address", text: $addAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Toggle("RSVP Required?", isOn: $rsvpRequired)
            Toggle("Enable Comments", isOn: $enableComments)

            Button("Post Event") {
                // Submit logic
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(hex: "#258694"))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
     }
  }


struct EventDatePickerField: View {
    @State private var selectedDate: Date? = nil
    @State private var showDatePicker = false
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
            
            HStack {
                Text(selectedDate != nil ? formatDate(selectedDate!) : "Select Date And Time")
                    .foregroundColor(selectedDate != nil ? .black : .gray)
                
                Spacer()
                
                Button(action: {
                    showDatePicker.toggle()
                }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
        }
        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker(
                    "",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    displayedComponents: [.date, .hourAndMinute]
                )
                .datePickerStyle(.graphical) // large calendar style
                .labelsHidden()
                .padding()
                
                Button("Done") {
                    showDatePicker = false
                }
                .padding()
            }
            .presentationDetents([.medium]) // iOS 16+ for sheet height
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


