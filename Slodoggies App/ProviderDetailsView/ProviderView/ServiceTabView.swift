//
//  ServiceTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ServicesTabView: View {
    let provider: ProviderModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Available Services–")
                .font(.custom("Outfit-SemiBold", size: 14))
                .foregroundColor(.black)
                .padding(.horizontal)

            ForEach(provider.services) { service in
                ServiceSectionView(service: service)
                    .padding(.horizontal)
            }
        }
    }
}


struct ServiceSectionView: View {
    let service: Service
    @State private var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            VStack(alignment: .leading, spacing: 10) {
                Text(service.description)
                    .font(.custom("Outfit-Regular", size: 14))
                    .foregroundColor(.black)

                HStack {
                    Text("Amount")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.black)
                    Spacer()
                    Text("$\(String(format: "%.2f", service.price))")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.black)
                }

                if !service.photos.isEmpty {
                    Text("Photos")
                        .font(.custom("Outfit-Medium", size: 14))
                        .foregroundColor(.black)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 3), spacing: 6) {
                        ForEach(service.photos.prefix(5), id: \.self) { photo in
                            Image(photo)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 70)
                                .clipped()
                                .cornerRadius(8)
                        }

                        if service.photos.count > 5 {
                            ZStack {
                                Image(service.photos[5])
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 70)
                                    .clipped()
                                    .cornerRadius(8)
                                    .blur(radius: 1)

                                Text("+\(service.photos.count - 5)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .shadow(radius: 2)
                            }
                        }
                    }
                }
            }
            .padding(.top, 8)
        } label: {
            HStack {
                Image("DogFoot1")
                    .frame(width: 15, height: 15)
                Text(service.title)
                    .font(.custom("Outfit-Medium", size: 14))
                    .foregroundColor(.black)
            }
         }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray.opacity(0.15), lineWidth: 1)
        )
        //.shadow(color: .gray.opacity(0.15), radius: 4)
     }
  }
