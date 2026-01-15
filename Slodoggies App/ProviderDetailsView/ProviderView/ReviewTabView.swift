//
//  ReviewTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct ReviewsTabView: View {
    let maxCount: Int = 1
    let businessID: Int
    @Binding var reviews: [BusiServiceReview]

    let ratingCounts: [Int]
    let averageRating: Double
    let totalReviews: Int

    var onTapReply: (BusiServiceReview) -> Void
    var onSendReply: (String, UUID) -> Void
    var onreviewSuccess: () -> Void = {}
    @State private var reviewText: String = ""
    @State private var selectedRating: Int = 0 // User’s rating
    @State private var ratingDescription = ""
    @StateObject private var keyboard = KeyboardResponder()
    @StateObject private var viewModel = ProviderProfileViewModel()

        var body: some View {
            VStack(spacing: 16) {
                RatingSummaryView(
                    ratingCounts: ratingCounts,
                    maxCount: totalReviews,
                    averageRating: averageRating,
                    totalReviews: totalReviews
                )

                LazyVStack(alignment: .leading, spacing: 16) {
                    ForEach(reviews) { review in
                        ReviewRow(
                            review: review,
                            onTapReply: {
                                onTapReply(review)
                            }
                        )
                        Divider()
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
                        viewModel.addReview(BusinessID: businessID, rating: selectedRating, message: ratingDescription, completion: { status in
                            if status{
                                self.selectedRating = 0
                                self.ratingDescription = ""
                                onreviewSuccess()
                            }
                        })
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
                
//                VStack(alignment: .leading, spacing: 16) {
//                   
//                }
                
            }
        }
  }

