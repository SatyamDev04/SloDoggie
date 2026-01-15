//
//  BusiAddServiceView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 01/09/25.
//

import SwiftUI
import PhotosUI

struct BusiAddServiceView: View {
    
    enum Mode {
            case add
            case edit
        }
    
    var mode: Mode = .add
    var Index: Int? = 0
    @StateObject private var viewModel = AddServiceViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    @State var serviceAddedPopUp: Bool = false
    @State var serviceUpdatedPopUp: Bool = false
    
    @State private var showPicker = false
    
    @State private var description = ""
    var  serviceID : String? = ""
    let gridLayout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4){
                    Button(action: {
                        coordinator.pop()
                        coordinator.shouldRefreshServices = true
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    Text(mode == .add ? "Add Service" : "Edit Service")
                        .font(.custom("Outfit-Medium", size: 20))
                        .fontWeight(.medium)
                        .foregroundColor(Color(hex: "#221B22"))
                        .padding(.leading, 10)
                    Spacer()
                }
                .padding(.horizontal, 14)
                
                let addService = UserDefaults.standard.string(forKey: "addService")
                if addService == "addService" {
                    Divider()
                        .frame(height: 2)
                        .background(Color(hex: "#258694"))
                }else{
                    ProgressView(value: 0.7)
                        .tint(Color(hex: "#258694"))
                }
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        // Service Title
                        Text("Service Title")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        TextField("Enter Title", text: $viewModel.title)
                            .customTextFieldStyle()
                            .padding(.bottom, 10)
                        
                        // Description
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Desription")
                                .font(.custom("Outfit-Medium", size: 14))
                            
                            PlaceholderTextEditor(placeholder: "Enter Description", text: $viewModel.description)
                                .frame(height: 120)
                            //.padding(.top)
                        }
                        //                    Text("Description")
                        //                        .font(.custom("Outfit-Medium", size: 14))
                        //                        .foregroundColor(.black)
                        //                    TextField("Type here", text: $viewModel.description)
                        //                        .customTextFieldStyle()
                        //                        .padding(.bottom, 10)
                        
                        // Price
                        Text("Price ($)")
                            .font(.custom("Outfit-Medium", size: 14))
                            .foregroundColor(.black)
                        TextField("Enter amount", text: $viewModel.price)
                            .keyboardType(.decimalPad)
                            .customTextFieldStyle()
                            .padding(.bottom, 10)
                        
                        // Upload Media
                        Text("Upload Media")
                            .font(.custom("Outfit-Medium", size: 14))
                            .padding(.bottom, 10)

                        Button {
                            //  CLEAR selection BEFORE opening gallery
                            viewModel.pickerItems = []
                            showPicker = true
                        } label: {
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
                        .photosPicker(
                            isPresented: $showPicker,
                            selection: $viewModel.pickerItems,
                            maxSelectionCount: 10,
                            matching: .images
                        )
                        .onChange(of: viewModel.pickerItems) { newItems in
                            Task {
                                await viewModel.loadPickerImages(newItems)
                            }
                        }

                        LazyVGrid(columns: gridLayout, spacing: 10) {
                            ForEach(viewModel.images.indices, id: \.self) { index in
                                ServiceImageCell(
                                    item: viewModel.images[index],
                                    onDelete: {
                                        viewModel.removeImage(at: index)
                                    }
                                )
                            }
                        }
                        .padding(.top)

                        
                        // Add Service Button
                        if mode == .edit {
                            Button(action: {
//                                viewModel.updateService()
//                                serviceUpdatedPopUp = true
                             
                                viewModel.AddYourBusinessApi { success in
                                    if success{
                                        serviceUpdatedPopUp = true
                                    }
                                }
                            }) {
                                Text("Edit Service")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#258694"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 10)
                        }else{
                            Button(action: {
                                viewModel.AddYourBusinessApi { success in
                                    if success{
                                        serviceAddedPopUp = true
                                    }
                                }
                            }) {
                                Text("Add Service")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#258694"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.top, 10)
                        }
                    }
                }
                .padding()
            }
            .overlay(
                Group {
                    if serviceAddedPopUp {
                        ServiceAddedSuccPopUp(
                            isVisible: $serviceAddedPopUp,
                            onAddAnother: {
                                       viewModel.resetForm()   // ✅ clear all fields
                                   }
                        )
                    }
                    if serviceUpdatedPopUp {
                        ServiceUpdatedSuccPopUpView(
                            isVisible: $serviceUpdatedPopUp,
                            onRemove: {
                                coordinator.shouldRefreshServices = true   // ✅ trigger refresh
                                coordinator.pop()
                                   }
                        )
                    }
                }
            )
            if viewModel.isLoading {
                CustomLoderView(isVisible: $viewModel.isLoading)
                    .ignoresSafeArea()
            }
            
            
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage))
        }
        
        .onAppear {
          //  viewModel.pickerItems = []
            if mode == .edit {
                viewModel.getBusinessServiceDetails()
            }
        }

        .onReceive(viewModel.$businessServiceResponse) { response in
            guard
                mode == .edit,
                let index = Index,
                let services = response?.services,
                services.indices.contains(index)
            else { return }

            let service = services[index]
            viewModel.serviceId = "\(service.serviceID ?? 0)"
            viewModel.title = service.serviceTitle ?? ""
            viewModel.description = service.description ?? ""
            viewModel.price = service.price ?? ""

            let urls =
                service.media?
                    .filter { $0.mediaType == .image }
                    .compactMap { $0.mediaURL } ?? []
            viewModel.setRemoteImages(urls)
        }
    }
  }

extension View {
    func customTextFieldStyle() -> some View {
        self
            .padding()
            .frame(height: 48) // Bigger height
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "#9C9C9C"), lineWidth: 0.6)
            )
    }
}

#Preview {
    BusiAddServiceView()
}


struct ServiceImageCell: View {
    let item: AddServiceViewModel.ServiceImage
    let onDelete: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {

            content
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            Button(action: onDelete) {
                Image("redcrossicon")
                    .resizable()
                    .frame(width: 17, height: 17)
            }
            .offset(x: 6, y: -6)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch item {
        case .remote(let url,_):
            
                Image.loadImage(
                    url,
                    cornerRadius: 12,
                    contentMode: .fill
                )
                .scaledToFill()
          
//            AsyncImage(url: URL(string: url)) { image in
//                image.resizable().scaledToFill()
//            } placeholder: {
//                ProgressView()
//            }

        case .local(_, let image):
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        }
    }
}
