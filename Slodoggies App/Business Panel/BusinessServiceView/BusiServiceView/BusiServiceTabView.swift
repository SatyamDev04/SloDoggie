////
////  ServiceTabView.swift
////  Slodoggies App
////
////  Created by YES IT Labs on 25/07/25.
////
//
//import SwiftUI
//
//
//struct BusiServiceTabView: View {
//    let provider: BusinessServiceModel?
//    @EnvironmentObject private var coordinator: Coordinator
//    let serviceIndex: Int
//    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void = { _, _ in }
//    var onDeleteTap: (_ index: Int) -> Void   // ✅ ADD
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            
//            Text("Available Services–")
//                .font(.custom("Outfit-SemiBold", size: 14))
//                .padding(.horizontal)
//                .padding(.top, 20)
//
//            ForEach((provider?.services ?? []).indices, id: \.self) { index in
//                let service = provider!.services?[index]
//
//                BusiServiceSectionView(
//                    service: service,
//                    serviceIndex: index,   // ✅ pass index
//                    onPhotoTap: onPhotoTap,
//                    onDeleteTap: onDeleteTap   // ✅ PASS
//                )
//                .padding(.horizontal)
//            }
//
//            
//            // Add Service Button
//            Button {
//                coordinator.push(.addServiceView(mode: .add, index: serviceIndex))
//            } label: {
//                Text("+ Add New Service")
//                    .font(.custom("Outfit-Medium", size: 14))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color(hex: "#258694"))
//                    .cornerRadius(12)
//            }
//            .padding(.horizontal, 60)
//            .padding(.vertical, 30)
//        }
//    }
//}
//
//
//struct BusiServiceSectionView: View {
//    let service: BusinessService?
//    @State private var isExpanded = false
//    @EnvironmentObject private var coordinator: Coordinator
//    
//    let serviceIndex: Int
//    
//   
//    
//    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void
//    
//    var onDeleteTap: (_ index: Int) -> Void   // ✅ ADD
//    
//    private var imageURLs: [String] {
//        service?.media?
//            .filter { $0.mediaType == .image }
//            .compactMap { $0.mediaURL } ?? []
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10) {
//
//            // Header
//            HStack {
//                HStack(spacing: 6) {
//                    Image("DogFoot1")
//                        .resizable()
//                        .frame(width: 15, height: 15)
//                    
//                    Text(service?.serviceTitle ?? "")
//                        .font(.custom("Outfit-Medium", size: 14))
//                }
//
//                Spacer()
//                
////                HStack(spacing: 16) {
////                    Button {
////                        coordinator.push(.addServiceView(mode: .edit, index: serviceIndex))
////                    } label: {
////                        Image("PencilIcons")
////                            .resizable()
////                            .frame(width: 20, height: 20)
////                    }
////
////                    Button {
////                        // delete action
////                        onDeleteTap(serviceIndex)   // ✅ send index to parent
////                    } label: {
////                        Image("reddeleteicon")
////                            .resizable()
////                            .frame(width: 20, height: 20)
////                    }
////                }
//                
//                Button {
//                  
//                    coordinator.push(.addServiceView(mode: .edit, index: serviceIndex))
//                } label: {
//                    Image("PencilIcons")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
//                .buttonStyle(.plain)
//
//                Button {
//                  
//                    onDeleteTap(serviceIndex)
//                } label: {
//                    Image("reddeleteicon")
//                        .resizable()
//                        .frame(width: 20, height: 20)
//                }
//                .buttonStyle(.plain)
//
//            }
//
//            // Expanded Content
//            if isExpanded {
//                VStack(alignment: .leading, spacing: 10) {
//
//                    Text(service?.description ?? "")
//                        .font(.custom("Outfit-Regular", size: 12))
//
//                    HStack {
//                        Text("Amount")
//                        Spacer()
//                        Text("\(service?.currency ?? "$") \(service?.price ?? "0")")
//                    }
//
//                    if !imageURLs.isEmpty {
//                        Text("Photos")
//
//                        LazyVGrid(
//                            columns: Array(repeating: .init(.flexible()), count: 3),
//                            spacing: 6
//                        ) {
//                            ForEach(imageURLs.indices.prefix(6), id: \.self) { index in
//                                AsyncImage(url: URL(string: imageURLs[index])) { img in
//                                    img.resizable()
//                                } placeholder: {
//                                    Color.gray.opacity(0.2)
//                                }
//                                .frame(height: 70)
//                                .cornerRadius(8)
//                                .onTapGesture {
//                                    onPhotoTap(imageURLs, index)
//                                }
//                            }
//                        }
//                    }
//                }
//                .padding(.top, 8)
//            }
//        }
//        .padding()
//        .background(Color.white)
//        .cornerRadius(12)
//        .overlay(
//            RoundedRectangle(cornerRadius: 8)
//                .stroke(Color.gray.opacity(0.15))
//        )
//        .highPriorityGesture(
//            TapGesture().onEnded {
//                withAnimation(.easeInOut) {
//                    isExpanded.toggle()
//                }
//            }
//        )
//
//
//    }
//}
//

import SwiftUI

struct BusiServiceTabView: View {
    let provider: BusinessServiceModel?
    @EnvironmentObject private var coordinator: Coordinator
    let serviceIndex: Int
    
    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void = { _, _ in }
    var onDeleteTap: (_ index: Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("Available Services–")
                .font(.custom("Outfit-SemiBold", size: 14))
                .padding(.horizontal)
                .padding(.top, 20)

            ForEach((provider?.services ?? []).indices, id: \.self) { index in
                let service = provider?.services?[index]

                BusiServiceSectionView(
                    service: service,
                    serviceIndex: index,
                    onPhotoTap: onPhotoTap,
                    onDeleteTap: onDeleteTap
                )
                .padding(.horizontal)
            }

            Button {
                coordinator.push(.addServiceView(mode: .add, index: serviceIndex))
            } label: {
                Text("+ Add New Service")
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "#258694"))
                    .cornerRadius(12)
            }
            .padding(.horizontal, 60)
            .padding(.vertical, 30)
        }
    }
}
import SwiftUI

struct BusiServiceSectionView: View {
    let service: BusinessService?
    let serviceIndex: Int

    @State private var isExpanded = false
    @EnvironmentObject private var coordinator: Coordinator

    var onPhotoTap: (_ photos: [String], _ index: Int) -> Void
    var onDeleteTap: (_ index: Int) -> Void

    private var imageURLs: [String] {
        service?.media?
            .filter { $0.mediaType == .image }
            .compactMap { $0.mediaURL } ?? []
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // 🔹 HEADER
            HStack {
                HStack(spacing: 6) {
                    Image("DogFoot1")
                        .resizable()
                        .frame(width: 15, height: 15)

                    Text(service?.serviceTitle ?? "")
                        .font(.custom("Outfit-Medium", size: 14))
                }

                Spacer()

                Button {
                    coordinator.push(.addServiceView(mode: .edit, index: serviceIndex))
                } label: {
                    Image("PencilIcons")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)

                Button {
                    onDeleteTap(serviceIndex)
                } label: {
                    Image("reddeleteicon")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .buttonStyle(.plain)
            }

            // 🔹 EXPANDED CONTENT
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
                .padding(.top, 6)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.15))
        )
        .contentShape(Rectangle()) // 🔥 whole row tappable
        .onTapGesture {
            withAnimation(.easeInOut) {
                isExpanded.toggle()
            }
        }
    }
}
