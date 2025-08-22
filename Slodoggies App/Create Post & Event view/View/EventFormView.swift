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
    @State private var showSuccessPopView: Bool = false
    
    let durations = ["30 mins", "1 hour", "2 hours", "Half Day", "Full Day"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            UploadMediaView()

            VStack(alignment: .leading, spacing: 8) {
                Text("Event Title")
                    .font(.custom("Outfit-Medium", size: 16))
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
                            .padding(.top)
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Event Desription")
                    .font(.custom("Outfit-Medium", size: 16))

                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
                    .padding(.top)
            }

                EventDatePickerField(title: "Event Start Date And Time")
                    .padding(.top)
                EventDatePickerField(title: "Event End Date And Time")
                    .padding(.top)
                
            }
                       
            // Event Duration
            VStack(alignment: .leading, spacing: 6) {
                Text("Event Duration")
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                    .padding(.top)
                
                HStack {
                    Text(selectedDuration.isEmpty ? "Select Duration" : selectedDuration)
                        .foregroundColor(selectedDuration.isEmpty ? .gray : .black)
                    
                    Spacer()
                    
                    ZStack {
                        Image(systemName: "chevron.down")
                            .foregroundColor(.gray)
                        
                        // Invisible picker overlay
                        Picker("", selection: $selectedDuration) {
                            Text("Select Duration").tag("")
                            ForEach(durations, id: \.self) { duration in
                                Text(duration)
                            }
                        }
                        .pickerStyle(.menu)
                        .opacity(0.02) // Invisible but clickable
                    }
                    .frame(width: 24, height: 24) // match icon size
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
                .tint(Color(hex: "#258694")) // Change toggle ON color
                   .scaleEffect(0.8) // Make toggle smaller
                   .padding(.vertical, 4)
                   .padding(.top)
            
            Toggle("Enable Comments", isOn: $enableComments)
                .tint(Color(hex: "#258694")) // Change toggle ON color
                   .scaleEffect(0.8) // Make toggle smaller
                   .padding(.vertical, 4)
            
            Button(action: {
                showSuccessPopView = true
            }){
                Text("Post Event")
                    .font(.custom("Outfit-Bold", size: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                
            }
            .padding(.top, 24)
            .frame(height: 34)
        }
        .overlay(
            Group{
                if showSuccessPopView{
                    PostCreatedSuccPopUp(isVisible: $showSuccessPopView)
                }
            }
        )
        .padding()
     }
  }


struct EventDatePickerField: View {
    @State private var selectedDate: Date? = nil
    @State private var showDatePicker = false
    @State private var fieldWidth: CGFloat = 0
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("Outfit-Medium", size: 16))
                .foregroundColor(.black)
            
            ZStack(alignment: .topLeading) {
                HStack {
                    Text(selectedDate != nil ? formatDate(selectedDate!) : "Select Date And Time")
                        .foregroundColor(selectedDate != nil ? .black : .gray)
                    
                    Spacer()
                    
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                fieldWidth = geo.size.width
                            }
                    }
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onTapGesture {
                    withAnimation {
                        showDatePicker.toggle()
                    }
                }
                
                if showDatePicker {
                    VStack(spacing: 0) {
                        Divider()
                        DatePicker(
                            "",
                            selection: Binding(
                                get: { selectedDate ?? Date() },
                                set: { selectedDate = $0 }
                            ),
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        
                        HStack {
                            Spacer()
                            Button("Done") {
                                withAnimation {
                                    showDatePicker = false
                                }
                            }
                            .padding(.bottom, 8)
                        }
                        .padding(.horizontal)
                    }
                    .frame(width: fieldWidth)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 4)
                    .offset(y: 50) // push it below the field
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


