//
//  PetPlacesPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 22/08/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct PetPlacesPopUpView: View {
    @State private var selectedReason: String? = nil
    @State private var message: String = ""
    @State private var feedbackMessage: String = ""
    @State private var isExpanded = false
    @State private var showMore = false
    let place: PetPlace
    var onCancel: (() -> Void)
    var onSubmit: (() -> Void)
    
    var body: some View {
        ZStack {
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Button(action: {
                        onCancel()
                    }) {
                        Image("crossIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                    .padding(.trailing, 7)
                }
                
                VStack(spacing: 10) {
                    // Title
                    HStack {
                        Text(place.title) // use dynamic place name
                            .font(.custom("Outfit-Medium", size: 20))
                        Spacer()
                    }
                    .padding()
                    .padding(.bottom, -10)
                    
                    Divider()
                        .frame(height: 1)
                        .background(Color(hex: "#258694"))
                        .padding(.horizontal)
                    
                    // Image
                    if let urlString = place.image,
                       let url = URL(string: urlString),
                       !urlString.isEmpty {
                        Image.loadImage(place.image)
//                        WebImage(url: url)
//                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.horizontal, 10)
                    }else{
                        Image("download")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 200)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .cornerRadius(12)
                            .padding(.horizontal, 10)
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Overview")
                            .font(.custom("Outfit-Medium", size: 16))
                            .foregroundColor(.black)
                            .padding(.top, 10)
                        
                        Divider()
                            .frame(height: 1)
                            .background(Color(hex: "#258694"))
                        
                        // Fixed Text concatenation
                        Text(place.overview)
                                .font(.custom("Outfit-Regular", size: 15))
                                .foregroundColor(.gray)
                                .lineLimit(isExpanded ? nil : 2)
                                .animation(.easeInOut, value: isExpanded)

                            if showMore && !isExpanded {
                                Text("more")
                                    .font(.custom("Outfit-Regular", size: 13))
                                    .foregroundColor(Color(hex: "#258694"))
                                    .underline()
                                    .onTapGesture {
                                        withAnimation {
                                            isExpanded = true
                                        }
                                    }
                            }

                            // Hidden measurer
                            TextSizeReader(
                                text: place.overview,
                                font: UIFont(name: "Outfit-Regular", size: 15)!,
                                lineLimit: 2,
                                width: UIScreen.main.bounds.width - 40
                            ) { needsMore in
                                showMore = needsMore
                            }
                        }
                    //.padding(.horizontal)
//                    .padding(.bottom, 40)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(16)
                }
                .background(Color(.systemBackground))
                .cornerRadius(16)
            }
            .padding(.bottom, -20)
            .padding(12)
        }
     }
  }

// #Preview {
//    PetPlacesPopUpView(onCancel: {}, onSubmit: {})
// }

