//
//  BusiEventFormView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/09/25.
//

import SwiftUI
import PhotosUI
import AVKit
import AVFoundation

struct BusiEventFormView: View {
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var eventStartDateTime = ""
    @State private var eventEndDateTime = ""
    @State private var title = ""
    @State private var description = ""
    @State private var date = Date()
    @State private var eventTitle = ""
    @State private var duration = ""
    //@State private var addAddress = ""
    @State private var StreetAddress = ""
    @State private var City = ""
    @State private var State = ""
    @State private var zipCode = ""
    @State private var useCurrentLocation = false
    @State private var rsvpRequired = true
    @State private var enableComments = true
    @State private var showdurationPicker = false
    @Binding var showEventSuccessPopView: Bool
    @StateObject private var viewModel = BusiPostEventViewModel()
    
    @State private var errorMessage: String? = nil
    @State private var showError = false
    var backAction: () -> () = {}
    
    let durations = ["30 mins", "1 hour", "2 hours", "Half Day", "Full Day"]
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
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
                    errorMessage = "You can't select more than 6 items"
                    showError = true
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
                
                TextField("Enter Title", text: $eventTitle)
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
           
            Text("Street Address")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter Street Address", text: $StreetAddress)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            Text("City")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter City", text: $City)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            Text("State")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter State", text: $State)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            
            Text("Zip Code")
                .font(.custom("Outfit-Medium", size: 14))
            
            TextField("Enter your Zip Code", text: $zipCode)
                .padding() // adds space inside
                .frame(height: 48) // final height
                .font(.custom("Outfit-Regular", size: 15))
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            
            Button(action: {
                if validateForm(){
                    showEventSuccessPopView = true
                }
            }){
                Text("Post Event")
                    .font(.custom("Outfit-Bold", size: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.bottom, 24)
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
        if eventTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
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
        if StreetAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter address")
            return false
        }
        if State.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter state")
            return false
        }
        if City.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter city")
            return false
        }
        if zipCode.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            showErrorPopup("Enter zipCode")
            return false
        }
            
            // All fields are filled and valid
            print("Form Submitted Successfully")
            backAction()
            return true
        }
        
        private func showErrorPopup(_ message: String) {
            errorMessage = message
            showError = true
        }
  }

#if DEBUG
struct BusiEventFormView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewBoolWrapper { binding in
            BusiPostFormView(showBusiPostSuccessPopView: binding)
        }
    }

    // Small helper to provide a Binding<Bool> in previews
    struct PreviewBoolWrapper<Content: View>: View {
        @State private var value: Bool = false
        let content: (Binding<Bool>) -> Content

        init(@ViewBuilder content: @escaping (Binding<Bool>) -> Content) {
            self.content = content
        }

        var body: some View {
            content($value)
        }
    }
}
#endif



//struct EventDatePickerField: View {
//    @State private var selectedDate: Date? = nil
//    @State private var showDatePicker = false
//    @State private var fieldWidth: CGFloat = 0
//    
//    var title: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 6) {
//            Text(title)
//                .font(.custom("Outfit-Regular", size: 15))
//                .foregroundColor(.black)
//            
//            ZStack(alignment: .topLeading) {
//                HStack {
//                    Text(selectedDate != nil ? formatDate(selectedDate!) : "Select Date And Time")
//                        .foregroundColor(selectedDate != nil ? .black : .gray.opacity(0.6))
//                        .font(.custom("Outfit-Regular", size: 14))
//                    Spacer()
//                    
//                    Image("datetimeicon")
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(.gray)
//                }
//                .padding()
//                .frame(height: 48)
//                .background(
//                    GeometryReader { geo in
//                        Color.clear
//                            .onAppear {
//                                fieldWidth = geo.size.width
//                            }
//                    }
//                )
//                .overlay(
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
//                )
//                .onTapGesture {
//                    withAnimation {
//                        showDatePicker.toggle()
//                    }
//                }
//                
//                if showDatePicker {
//                    VStack(spacing: 0) {
//                        Divider()
//                        DatePicker(
//                            "",
//                            selection: Binding(
//                                get: { selectedDate ?? Date() },
//                                set: { selectedDate = $0 }
//                            ),
//                            displayedComponents: [.date, .hourAndMinute]
//                        )
//                        .datePickerStyle(.graphical)
//                        .labelsHidden()
//                        .padding()
//                        
//                        HStack {
//                            Spacer()
//                            Button("Done") {
//                                withAnimation {
//                                    showDatePicker = false
//                                }
//                            }
//                            .padding(.bottom, 8)
//                        }
//                        .padding(.horizontal)
//                    }
//                    .frame(width: fieldWidth)
//                    .background(Color.white)
//                    .cornerRadius(8)
//                    .shadow(radius: 4)
//                    .offset(y: 50) // push it below the field
//                    .transition(.move(edge: .top).combined(with: .opacity))
//                }
//            }
//        }
//        // add bottom spacing dynamically
//        .padding(.bottom, showDatePicker ? 60 : 12)
//    }
//
//    func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        return formatter.string(from: date)
//    }
//}
