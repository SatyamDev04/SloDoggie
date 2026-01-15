//
//  AvailabilitySelectorView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 13/08/25.
//


import SwiftUI

struct AvailabilitySelectorView: View {
    @Binding var availableDays: String
    @Binding var fromTime: Date
    @Binding var toTime: Date
    
    @State private var selectedDays: Set<String> = []
    var onDone: () -> Void = {}
    
    let daysLeft = ["All", "Monday", "Tuesday", "Wednesday"]
    let daysRight = ["Sunday", "Thursday", "Friday", "Saturday"]
    
    var body: some View {
        VStack(spacing: 16) {
            
            // Days Selection Grid
            HStack(alignment: .top, spacing: 30) {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(daysLeft, id: \.self) { day in
                        dayRow(day)
                    }
                }
                Spacer()
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(daysRight, id: \.self) { day in
                        dayRow(day)
                    }
                }
            }
            
            // Time Selection
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("From")
                        .font(.custom("Outfit-Regular", size: 14))
                    DatePicker("", selection: $fromTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    Text("To")
                        .font(.custom("Outfit-Regular", size: 14))
                    DatePicker("", selection: $toTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
            }
            
            // Done Button
            Button(action: {
                let daysString = selectedDays.sorted().joined(separator: ", ")
                availableDays = "\(daysString) (\(formatDate(fromTime)) - \(formatDate(toTime)))"
                onDone()
            }) {
                Text("Done")
                    .foregroundColor(.white)
                    .font(.custom("Outfit-Medium", size: 16))
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(6)
            }
        }
        .padding(10)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(4)
//        .onAppear(){
//            selectedDays = Set(
//                availableDays
//                    .split(separator: ",")
//                    .map { $0.trimmingCharacters(in: .whitespaces) }
//                    .filter { !$0.isEmpty }
//            )
//        }
    }
    
    func dayRow(_ day: String) -> some View {
        Button(action: {
            if day == "All" {
                if selectedDays.contains("All") {
                    selectedDays.removeAll()
                } else {
                    selectedDays = Set(daysLeft + daysRight)
                }
            } else {
                if selectedDays.contains(day) {
                    selectedDays.remove(day)
                } else {
                    selectedDays.insert(day)
                }
            }
        }) {
            HStack {
                Image(systemName: selectedDays.contains(day) ? "checkmark.square.fill" : "square")
                    .foregroundColor(selectedDays.contains(day) ? Color(hex: "#258694") : .gray)
                Text(day)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.black)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.string(from: date)
    }
}

struct ClearTimePicker: View {
    @State private var selectedDate: Date? = nil
    @State private var showingPicker = false
    
    var body: some View {
        HStack {
            Text(selectedDate != nil ? formatDate(selectedDate!) : "--:--")
                .foregroundColor(selectedDate != nil ? .black : .gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "clock")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .onTapGesture {
            showingPicker = true
        }
        .sheet(isPresented: $showingPicker) {
            VStack {
                DatePicker("Select Time", selection: Binding(
                    get: { selectedDate ?? Date() },
                    set: { newValue in
                        selectedDate = newValue
                    }
                ), displayedComponents: .hourAndMinute)
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .colorScheme(.light)
                
                Button("Done") {
                    showingPicker = false
                }
                .padding()
            }
            .presentationDetents([.fraction(0.3)])
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a" // change to "hh-mm a" if needed
        return formatter.string(from: date)
    }
}
#Preview {
    AvailabilitySelectorView(
        availableDays: .constant("Monday, Wednesday (09:00 AM - 05:00 PM)"),
        fromTime: .constant(Date()),
        toTime: .constant(Date())
    )
}
