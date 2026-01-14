//
//  ReviewTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ReviewsTabView: View {
    @Binding var reviews: [BusiServiceReview]
    
    let ratingCounts: [Int] = [40, 25, 15, 5, 2] // From to 1
    let maxCount: Int = 40 // Max bar length reference
    let averageRating: Double = 4.0
    let totalReviews: Int = 52
    
    @State private var reviewText: String = ""
    @State private var selectedRating: Int = 0 // User’s rating
    @State private var ratingDescription = ""
    @StateObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top) {
                // Rating Bars
                VStack(alignment: .leading, spacing: 10) {
                    ForEach((1...5).reversed(), id: \.self) { star in
                        HStack(spacing: 8) {
                            // Star label + icon
                            HStack(spacing: 2) {
                                Text("\(star)")
                                    .font(.caption)
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .foregroundColor(.orange)
                            }
                            .frame(width: 30, alignment: .leading) // keeps all aligned

                            // Rating bar + count in one line
                            GeometryReader { geometry in
                                let widthRatio = CGFloat(ratingCounts[5 - star]) / CGFloat(maxCount)
                                HStack(spacing: 6) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Color(hex: "#258694"))
                                        .frame(width: geometry.size.width * widthRatio, height: 8)

                                    Text("\(ratingCounts[5 - star])")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .fixedSize() // always visible
                                }
                                .frame(width: geometry.size.width, alignment: .leading)
                            }
                            .frame(height: 8)
                        }
                    }
                }
                .padding(.trailing, 30)
                .frame(maxWidth: .infinity)
                .padding(.trailing, 40)
                .padding(.leading, 0)
                
                // Rating & Count
                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1f", averageRating))
                        .font(.custom("Outfit-Bold", size: 40))
                    
                    HStack(spacing: 2) {
                        ForEach(0..<5, id: \.self) { i in
                            Image(systemName: i < Int(averageRating) ? "star.fill" : "star")
                                .foregroundColor(.orange)
                                .font(.caption)
                        }
                    }
                    
                    Text("\(totalReviews) Reviews")
                        .font(.custom("Outfit-SemiBold", size: 14))
                        .foregroundColor(.black)
                }
            }
            //.padding()
            .padding(.top, 10)
            .padding(.bottom, 10)
            .padding(.horizontal, 16)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.blue.opacity(0.1), lineWidth: 2)
            )
            .accentColor(Color(hex: "#258694"))
            .padding(.horizontal, 16)
           
            // Review List
            VStack(alignment: .leading) {
                ForEach(reviews) { review in
                    VStack(alignment: .leading) {
                        HStack {
                            Image("People1")
                                .resizable()
                                .frame(width: 38, height: 38)
                            VStack(alignment: .leading) {
                                Text(review.reviewerName)
                                    .font(.custom("Outfit-Medium", size: 16))
                                    .foregroundColor(.black)
                                
                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { i in
                                        Image(systemName: i < Int(averageRating) ? "star.fill" : "star")
                                            .foregroundColor(Color(hex: "#ECA73F"))
                                            .font(.caption)
                                    }
                                    Text(review.timeAgo)
                                        .font(.custom("Outfit-Medium", size: 10))
                                        .foregroundColor(Color(hex: "#9C9C9C"))
                                        .padding(.leading, 4)
                                }
                            }
                        }
                        .padding(.vertical, 8)
                        
                        Text(review.comment)
                            .font(.custom("Outfit-Regular", size: 12))
                            .padding(.top, -5)
                            .padding(.bottom)
                        
                        Divider()
                    }
                }
                
                // Rate & Review
                Text("Rate & Review")
                    .font(.custom("Outfit-Medium", size: 14))
                    .padding(.top)
                Divider()
                
                // Star selection
                HStack {
                    ForEach(1...5, id: \.self) { star in
                        Image(systemName: star <= selectedRating ? "star.fill" : "star")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(star <= selectedRating ? .orange : .gray) // black for selected, gray for unselected
                            .onTapGesture {
                                selectedRating = star
                            }
                    }
                }
                .padding(.vertical, 8)
                
                // TextEditor with Placeholder
                PlaceholderTextEditor(placeholder: "Type Here.....", text: $ratingDescription)
                    .frame(height: 140)
                
                Button(action: {
                    // Handle review submission here
                    print("User rating: \(selectedRating)")
                    print("User review: \(reviewText)")
                }) {
                    Text("Submit")
                        .font(.custom("Outfit-Bold", size: 15))
                        .foregroundColor(.white)
                        .frame(height: 43)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(10)
                }
                .padding(.top, 11)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, keyboard.currentHeight)
        }
        .padding(.top, 20)
        .ignoresSafeArea(.keyboard, edges: .bottom)
     }
  }

