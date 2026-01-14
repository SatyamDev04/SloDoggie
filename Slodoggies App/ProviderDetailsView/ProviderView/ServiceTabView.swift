//
//  ServiceTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ServicesTabView: View {
    let provider: BusinessServiceModel?
    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Services–")
                .font(.custom("Outfit-SemiBold", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal)

//            ForEach(provider.services) { service in
//                ServiceSectionView(service: service, onPhotoTap: onPhotoTap)
//                    .padding(.horizontal)
//            }
            ForEach((provider?.services ?? []).indices, id: \.self) { index in
                let service = provider!.services?[index]

                ServiceSectionView(
                    service: service,
                    serviceIndex: index,   // ✅ pass index
                    onPhotoTap: onPhotoTap
                )
                .padding(.horizontal)
            }
        }
    }
}

struct ServiceSectionView: View {
    let service: BusinessService?
    @State private var isExpanded = false
    @EnvironmentObject private var coordinator: Coordinator
    
    let serviceIndex: Int
    
    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void
    
    private var imageURLs: [String] {
        service?.media?
            .filter { $0.mediaType == .image }
            .compactMap { $0.mediaURL } ?? []
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // Header
            HStack(spacing: 6) {
                Image("DogFoot1")
                    .resizable()
                    .frame(width: 15, height: 15)
                
                Text(service?.serviceTitle ?? "")
                    .font(.custom("Outfit-Medium", size: 14))
                Spacer()
            }
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {

                    Text(service?.description ?? "")
                        .font(.custom("Outfit-Regular", size: 12))

                    HStack {
                        Text("Amount")
                        Spacer()
                        Text("\(service?.currency ?? "$") \(service?.price ?? "0")")
                    }

                    if !imageURLs.isEmpty {
                        Text("Photos")

                        LazyVGrid(
                            columns: Array(repeating: .init(.flexible()), count: 3),
                            spacing: 6
                        ) {
                            ForEach(imageURLs.indices.prefix(6), id: \.self) { index in
                                
                                AsyncImage(url: URL(string: imageURLs[index])) { img in
                                    img.resizable()
                                } placeholder: {
                                    Color.gray.opacity(0.2)
                                }
                                .frame(height: 70)
                                .cornerRadius(8)
                                .onTapGesture {
                                    onPhotoTap(imageURLs, index)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.15))
        )
        .contentShape(Rectangle()) // 🔥 makes entire card tappable
        .onTapGesture {
            withAnimation(.easeInOut) {
                isExpanded.toggle()
            }
        }
    }
}




struct ImageViewer: View {
    let photos: [String]
    @Binding var selectedIndex: Int
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()

            VStack {
                Spacer()
                Image(photos[selectedIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 400)
                    .cornerRadius(12)
                Spacer()

                // Navigation Controls
                HStack {
                    Button(action: {
                        if selectedIndex > 0 { selectedIndex -= 1 }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                    Button(action: {
                        if selectedIndex < photos.count - 1 { selectedIndex += 1 }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                .padding(.horizontal, 30)
            }

            // Close Button
            VStack {
                HStack {
                    Spacer()
                    Button(action: { isPresented = false }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                Spacer()
            }
        }
    }
}
