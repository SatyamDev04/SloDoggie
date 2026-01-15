//
//  EventFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 29/07/25.
//

import SwiftUI
import PhotosUI

struct EventFormView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var eventStartDateTime = ""
    @State private var eventEndDateTime = ""
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var duration = ""
    //@State private var addAddress = ""
    @State private var StreetAddress = ""
    @State private var City = ""
    @State private var State = ""
    @State private var zipCode = ""
    @State private var lat = ""
    @State private var long = ""
    @State private var useCurrentLocation = false
    @State private var rsvpRequired = true
    @State private var enableComments = true
    @State private var showdurationPicker = false
    @Binding var showEventSuccessPopView: Bool
//    @StateObject private var viewModel = CreatePostViewModel()
    @ObservedObject var viewModel: CreatePostViewModel
    @State private var errorMessage: String? = nil
    @State private var showError = false
   
    var backAction: (eventData) -> () = {_ in}
    var errorHandeler: (String) -> () = { _ in }
    let durations = ["30 mins", "1 hour", "2 hours", "Half Day", "Full Day"]
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var onAddressTap: () -> () = { }
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Upload Media")
                .font(.custom("Outfit-Medium", size: 14))
                .padding(.top)
            
            if viewModel.selectedMedia.count < 6 {
                PhotosPicker(
                    selection: $viewModel.pickerItems,
                    maxSelectionCount: max(0, 6 - viewModel.selectedMedia.count),
                    matching: .any(of: [.images, .videos])
                ) {
                    VStack {
                        Image("material-symbols_upload")
                            .font(.title)
                        Text("Upload Here")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(Color(hex: "#258694"))
                    }
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(Color(hex: "#258694"))
                    )
                }
                .onChange(of: viewModel.pickerItems) { newItems in
                    Task {
                        await viewModel.addMedia(from: newItems)
                    }
                }
            } else {
                VStack {
                    Image("material-symbols_upload")
                        .font(.title)
                    Text("Upload Here")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(Color(hex: "#258694"))
                }
                .frame(maxWidth: .infinity, minHeight: 100)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 229/255, green: 239/255, blue: 242/255))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(Color(hex: "#258694"))
                )
                .onTapGesture {
//                    errorMessage = "You can't select more than 6 items"
//                    showError = true
                    errorHandeler("You can't select more than 6 items")
                }
            }

            // Selected Media Grid
            LazyVGrid(columns: gridLayout, spacing: 10) {
                ForEach(Array(viewModel.selectedMedia.enumerated()), id: \.1.id) { idx, media in
                    ZStack(alignment: .topTrailing) {
                        if let image = media.image {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else if let url = media.videoURL {
                            VideoThumbnailView(videoURL: url)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        } else {
                            Rectangle()
                                .frame(width: 100, height: 100)
                                .foregroundColor(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }

                        Button(action: {
                            viewModel.removeMedia(at: idx)
                        }) {
                            Image("redcrossicon")
                                .resizable()
                                .frame(width: 17, height: 17)
                        }
                        .offset(x: 6, y: -6)
                    }
                }
            }
            .padding(.top)

            VStack(alignment: .leading, spacing: 8) {
                Text("Event Title")
                    .font(.custom("Outfit-Medium", size: 14))
                
                TextField("Enter Title", text: $title)
                    .padding(.vertical, 12) // increases height inside
                    .padding(.horizontal, 10) // keeps horizontal spacing nice
                    .cornerRadius(8)
                    .font(.custom("Outfit-Regular", size: 15))
                    .frame(height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                    .padding(.top, 8)
                
            VStack(alignment: .leading, spacing: 8) {
                Text("Event Desription")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.top)
                
                PlaceholderTextEditor(placeholder: "Enter Description", text: $description)
                    .frame(height: 120)
                    //.padding(.top)
            }
                EventDatePickerField(selectedDateTime: $eventStartDateTime, title: "Event Start Date And Time")
                    .padding(.top)
                
                EventDatePickerField(selectedDateTime: $eventEndDateTime, title: "Event End Date And Time")
                    .font(.custom("Outfit-Medium", size: 14))
                
            }
            .padding(.top, -8)
           
            Text("Street address")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter Street Address", text: $viewModel.address)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                .disabled(true)
                .onTapGesture {
                    onAddressTap()   // sheet opens normally
                }
            
            Text("City")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter City", text: $viewModel.city)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            Text("State")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter State", text: $viewModel.state)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            
            Text("Zip Code")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter your Zip Code", text: $viewModel.zipCode)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            Button(action: {
                if validateForm(){
                    // All fields are filled and valid
                    print("Form Submitted Successfully")
                
                    backAction(eventData(eventTitle: title,media: viewModel.selectedMedia,eventDesc: description,startDateTime: eventStartDateTime,endDateTime: eventEndDateTime,address: viewModel.address,city: viewModel.city,zipCode: viewModel.zipCode,latitude: "\(viewModel.latitude ?? 0.0)",longitude: "\(viewModel.longitude ?? 0.0)"))
                }
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
            .padding(.top, 24)
        }
//        .overlay(
//            Group{
//                if showSuccessPopView{
//                    PostCreatedSuccPopUp(isVisible: $showSuccessPopView)
//                }
//            }
//        )
        .padding()
        .alert(isPresented: $showError) {
            Alert(
                title: Text(""),
                message: Text(errorMessage ?? "Unknown error"),
                dismissButton: .default(Text("OK"))
            )
        }
     }
    
    // MARK: Validation
    private func validateForm() -> Bool {
        if title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter event title")
            return false
        }
        if description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter description")
            return false
        }
        if eventStartDateTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter event start date time")
            return false
        }
        if eventEndDateTime.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter event end date time")
            return false
        }
        if viewModel.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter address")
            return false
        }
        if viewModel.city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter city")
            return false
        }
        if viewModel.state.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter state")
            return false
        }
        if viewModel.zipCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter zipCode")
            return false
        }
            return true
        }
        
        private func showErrorPopup(_ message: String) {
            errorMessage = message
            errorHandeler(message)
        }
  }


struct EventDatePickerField: View {
    @Binding var selectedDateTime: String
    @State private var tempDate = Date()
    @State private var showDatePicker = false
    @State private var fieldWidth: CGFloat = 0
    
    var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.custom("Outfit-Regular", size: 15))
                .foregroundColor(.black)
            
            ZStack(alignment: .topLeading) {
                HStack {
                    Text(!selectedDateTime.isEmpty ? selectedDateTime : "Select Date And Time")
                        .foregroundColor(!selectedDateTime.isEmpty ? .black : .gray.opacity(0.6))
                        .font(.custom("Outfit-Regular", size: 14))
                    Spacer()
                    
                    Image("datetimeicon")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding()
                .frame(height: 48)
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
                            selection: $tempDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                        .labelsHidden()
                        .padding()
                        .onChange(of: tempDate) { newDate in
                            selectedDateTime = formatDate(newDate)
                        }
                        
                        HStack {
                            Spacer()
                            Button("Done") {
                                selectedDateTime = formatDate(tempDate)
                                print(selectedDateTime)
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
                    .offset(y: 50)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
        .padding(.bottom, showDatePicker ? 60 : 12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
