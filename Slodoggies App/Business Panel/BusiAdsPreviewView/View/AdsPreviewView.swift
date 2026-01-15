//
//  AdsPreviewView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 11/09/25.
//

import SwiftUI

struct AdsPreviewView: View {
    var adsDetail: adsDataModel
    @StateObject private var viewModel = AdsPreviewViewModel()
//    @StateObject private var viewModel = CreatePostViewModel()
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        ZStack{
            VStack(alignment: .leading, spacing: 16) {
                HStack(spacing: 20){
                    Button(action: {
                        coordinator.pop()
                    }){
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 20)
                    }
                    Text("Preview Ad")
                        .font(.custom("Outfit-Medium", size: 22))
                        .foregroundColor(Color(hex: "#221B22"))
                    //.padding(.leading, 100)
                    
                }
                //.padding(.leading)
                
                Divider()
                    .frame(height: 2)
                    .background(Color(hex: "#258694"))
                
                // MARK: Header
                ScrollView{
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image("adprofile") // Replace with actual profile image
                                .resizable()
                                .frame(width: 32, height: 32)
                                .clipShape(Circle())
                                .padding(.leading)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(UserDetail.shared.getName())
                                    .font(.custom("Outfit-Medium", size: 12))
                                Text("Just now")
                                    .font(.custom("Outfit-Regular", size: 12))
                                    .foregroundColor(Color(hex: "#9C9C9C"))
                            }
                            
                            Spacer()
                            
                        }
                        
                        Text("Summer Special: 20% Off Grooming!")
                            .font(.custom("Outfit-Bold", size: 13))
                            .padding(.leading)
                        Text("Limited Time Offer")
                            .font(.custom("Outfit-Regular", size: 12))
                            .padding(.leading)
                    }
                    
                    // MARK: Ad Image
                    ZStack(alignment: .bottomLeading) {
                        ForEach(adsDetail.media ?? []) { media in
                            if let uiImage = media.image {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: 350
                                    )
                                    .clipped()
                            } else if let videoURL = media.videoURL {
                                VideoThumbnailView(videoURL: videoURL)
                                    .frame(
                                        width: UIScreen.main.bounds.width,
                                        height: 350
                                    )
                                    .clipped()
                            }

                        }
                        //                    Image("sponserdImage") // Replace with ad image
                        //                        .resizable()
                        //                        .scaledToFill()
                        //                        .frame(height: 350)
                        //                        .clipped()
                        
                        // Sponsored Tag
                        HStack {
                            Text("Sponsored")
                                .font(.custom("Outfit-Medium", size: 16))
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "#258694"))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color(hex: "#258694"))
                    }
                    
                    
                    // MARK: Ad Details
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Circle() // bullet
                                .fill(Color(hex: "#258694"))
                                .frame(width: 6, height: 6)
                            
                            Text("Ad Details")
                                .font(.custom("Outfit-SemiBold", size: 18)) // or .headline if you want system font
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .padding()
                        
                        HStack {
                            (
                                Text("Ad Title:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                    .foregroundColor(.black)
                                +
                                Text((" \(adsDetail.adTitle ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Description:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(adsDetail.adDescription ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Category:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(adsDetail.category?.joined(separator: ",") ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Service:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(adsDetail.service ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Expiry Date & Time:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(formattedExpiry)"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Terms & Conditions:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(adsDetail.tNc ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                    }
                    //.font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    // MARK: Engagement & Location
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Circle() // bullet
                                .fill(Color(hex: "#258694"))
                                .frame(width: 6, height: 6)
                            
                            Text("Engagement & Location")
                                .font(.custom("Outfit-SemiBold", size: 18)) // or .headline if you want system font
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .padding()
                        
                        HStack {
                            (
                                Text("Location Type:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \(adsDetail.address ?? "")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Contact Info Display:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text((" \((adsDetail.contactShowStatus != nil) ? "Yes" : "No")"))
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Mobile Number:")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                +
                                Text("\( adsDetail.contactInfo ?? "")")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // .font(.subheadline)
                    
                    
                    // MARK: Pricing
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 6) {
                            Circle() // bullet
                                .fill(Color(hex: "#258694"))
                                .frame(width: 6, height: 6)
                            
                            Text("Pricing & Reach Estimates")
                                .font(.custom("Outfit-SemiBold", size: 18)) // or .headline if you want system font
                                .foregroundColor(Color(hex: "#258694"))
                        }
                        .padding()
                        
                        HStack {
                            (
                                Text("Daily Budget: $")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                //                                +
                                //                                Text((" \(adsDetail.budget ?? "", specifier: "%.2f")"))
                                //                                    .foregroundColor(.black)
                                //                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                        
                        HStack {
                            (
                                Text("Ad Budget: $")
                                    .foregroundColor(.black)
                                    .font(.custom("Outfit-SemiBold", size: 14))
                                //                                +
                                //                                Text((" \(viewModel.ad.adBudget, specifier: "%.2f") per day"))
                                //                                    .foregroundColor(.black)
                                //                                    .font(.custom("Outfit-Regular", size: 14))
                            )
                        }
                        .padding(.leading, 5)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // .font(.subheadline)
                    
                    
                    // Submit Button
                    Button(action: {
                        print("Submit tapped")
                        
                        viewModel.createAddApi(adsData: self.adsDetail) { status in
                            if status{
                                coordinator.push(.adsDashboardView)
                            }
                        }
                        
                    }) {
                        Text("Submit")
                            .font(.custom("Outfit-Medium", size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#258694"))
                            .cornerRadius(10)
                            .padding(.top)
                            .padding(.horizontal, 6)
                    }
                }
                .padding()
            }
            if viewModel.showActivity{
                CustomLoderView(isVisible: $viewModel.showActivity)
            }
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text(viewModel.errorMessage ?? ""))
        }
    }
    
    
    var formattedExpiry: String {
        let inputFormatter = ISO8601DateFormatter()

        guard let date = inputFormatter.date(from: adsDetail.expiryDate ?? "") else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd/yyyy - hh:mm a"
        outputFormatter.timeZone = TimeZone.current

        return outputFormatter.string(from: date)
    }
}

#Preview {
    AdsPreviewView(adsDetail: adsDataModel())
}
