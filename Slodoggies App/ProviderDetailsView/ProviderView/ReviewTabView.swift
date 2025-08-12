//
//  ReviewTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ReviewsTabView: View {
    let reviews: [Review]
    
    let ratingCounts: [Int] = [40, 25, 15, 5, 2] // From 5⭐ to 1⭐
    let maxCount: Int = 40 // Max bar length reference
    let averageRating: Double = 4.0
    let totalReviews: Int = 52
    @State private var reviewText: String = ""
    
    var body: some View {
        HStack(alignment: .top) {
            // Rating Bars
            VStack(alignment: .leading, spacing: 6) {
                ForEach((1...5).reversed(), id: \.self) { star in
                    HStack {
                        Text("\(star)")
                            .font(.caption)
                        Image(systemName: "star.fill")
                            .resizable()
                            .frame(width: 8, height: 8)
                            .foregroundColor(.orange)
                        
                        GeometryReader { geometry in
                            let widthRatio = CGFloat(ratingCounts[5 - star]) / CGFloat(maxCount)
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "#258694"))
                                .frame(width: geometry.size.width * widthRatio, height: 6)
                        }
                        .frame(height: 6)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            // Rating & Count
            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", averageRating))
                    .font(.system(size: 32, weight: .bold))
                
                HStack(spacing: 2) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < Int(averageRating) ? "star.fill" : "star")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                }
                
                Text("\(totalReviews) Reviews")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
            
        }
        .padding()
        .padding(.leading, 16)
        .padding(.trailing, 16)
        
        VStack(alignment: .leading) {
            ForEach(reviews) { review in
                VStack(alignment: .leading) {
                    HStack {
                        Image("People1")
                            .resizable()
                            .frame(width: 38, height: 38)
                        VStack{
                            Text(review.reviewerName)
                                .font(.custom("Outfit-Medium", size: 16))
                                .padding(.leading,2)
                                .foregroundColor(.black)
                            HStack(spacing: 2) {
                                ForEach(0..<5, id: \.self) { i in
                                    Image(systemName: i < Int(averageRating) ? "star.fill" : "star")
                                        .foregroundColor(.orange)
                                        .font(.caption)
                                }
                                Text(review.timeAgo) .font(.custom("Outfit-Medium", size: 10))
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Text(review.comment)
                        .font(.custom("Outfit-Regular", size: 12))
                        .padding(.top, 12)
                        .padding(.bottom)
                    
                    Divider()
                }
            }
               
                 Text("Rate & Review")
                .padding(.top)
                 Divider()
            
            HStack {
                ForEach(1...5, id: \.self) { _ in
                    Image(systemName: "star")
                }
            }
            .padding()
            
            ZStack(alignment: .topLeading) {
                if reviewText.isEmpty {
                    Text("Type Here...")
                        .foregroundColor(.gray)
                        .font(.custom("Outfit-Regular", size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 16) // Matches TextEditor's default top padding
                }

                TextEditor(text: $reviewText)
                    .padding(4)
                    .font(.custom("Outfit-Regular", size: 14))
                    .background(Color.clear) // Important: prevents background from hiding placeholder
            }
            .frame(height: 100)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
            
            Button(action: {
                
            }){
                Text("Submit")
                    .font(.custom("Outfit-Bold", size: 15))
                    .foregroundColor(.white)
                    .padding(.leading, 18)
                    .padding(.trailing, 18)
                    .frame(height: 43)
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: "#258694"))
                    .cornerRadius(10)
            }
            .padding(.top, 11)
        }
        .padding()
        .padding(.leading, 16)
        .padding(.trailing, 16)
    }
}
