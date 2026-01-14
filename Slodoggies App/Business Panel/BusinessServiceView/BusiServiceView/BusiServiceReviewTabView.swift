//
//  ReviewTabView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 25/07/25.
//

import SwiftUI

struct BusiServiceReviewsTabView: View {
//    @Binding var reviews: [BusiServiceReview]
//
//    let ratingCounts: [Int] = [40, 25, 15, 5, 2]
    let maxCount: Int = 1
//    let averageRating: Double = 4.0
//    let totalReviews: Int = 52
    
    @Binding var reviews: [BusiServiceReview]

       let ratingCounts: [Int]
       let averageRating: Double
       let totalReviews: Int

       var onTapReply: (BusiServiceReview) -> Void
       var onSendReply: (String, UUID) -> Void

//    var onTapReply: (BusiServiceReview) -> Void
//    var onSendReply: (String, UUID) -> Void

    var body: some View {
        VStack(spacing: 16) {
            RatingSummaryView(
                ratingCounts: ratingCounts,
                maxCount: maxCount,
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
            }
            .padding(.horizontal, 16)
        }
    }
}



// MARK: - Pieces

struct RatingSummaryView: View {
    let ratingCounts: [Int]
    let maxCount: Int
    let averageRating: Double
    let totalReviews: Int

    private let starsOrder: [Int] = [5, 4, 3, 2, 1]

    var body: some View {
        HStack(alignment: .top, spacing: 40) {
            VStack(alignment: .leading, spacing: 6) {
                ForEach(starsOrder, id: \.self) { star in
                    RatingBarRow(
                        star: star,
                        count: count(for: star),
                        maxCount: maxCount
                    )
                }
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .trailing, spacing: 4) {
                Text(String(format: "%.1f", averageRating))
                    .font(.system(size: 32, weight: .bold))
                StarsView(rating: averageRating)
                Text("\(totalReviews) Reviews")
                    .font(.footnote)
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 26)
    }

    private func count(for star: Int) -> Int {
        let index = 5 - star
        return ratingCounts.indices.contains(index) ? ratingCounts[index] : 0
    }
}

struct RatingBarRow: View {
    let star: Int
    let count: Int
    let maxCount: Int

    var body: some View {
        HStack(spacing: 6) {
            // Star label + icon
            Text("\(star)")
                .font(.caption)
            Image(systemName: "star.fill")
                .resizable()
                .frame(width: 8, height: 8)
                .foregroundColor(.orange)

            // Rating bar with dynamic width
            if count == 0{
                Spacer()
            }else{
                GeometryReader { geo in
                    let ratio = CGFloat(max(min(count, maxCount), 0)) / CGFloat(max(1, maxCount))
                    HStack(spacing: 14) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#258694"))
                            .frame(width: geo.size.width * ratio, height: 6)
                        
                        // Rating count after the bar
                        Text("\(count)")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .frame(minWidth: 24, alignment: .leading)
                    }
                }
                .frame(height: 6)
            }
        }
    }
}


struct ReviewRow: View {
    let review: BusiServiceReview
    let onTapReply: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ReviewerHeader(
                profileImg: review.user?.profileImage ?? "", name: review.reviewerName,
                rating: review.rating,
                time: review.timeAgo
            )

            Text(review.comment)
                .font(.custom("Outfit-Regular", size: 12))
                .foregroundColor(.black)
                .padding(.vertical, 4)

            if let reply = review.reply {
                ReplyBubble(reply: reply)
            }

            Button(action: onTapReply) {
                Text("Reply")
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(Color(hex: "#258694"))
            }
            .buttonStyle(.plain)
            .padding(.leading, 40)
        }
     }
  }

struct ReviewerHeader: View {
    let profileImg:String
    let name: String
    let rating: Int
    let time: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image.loadImage(profileImg)
//                .resizable()
                .frame(width: 38, height: 38)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.custom("Outfit-Medium", size: 16))
                    .foregroundColor(.black)
                HStack(spacing: 4) {
                    ForEach(0..<5, id: \.self) { i in
                        Image(systemName: i < rating ? "star.fill" : "star")
                            .foregroundColor(.orange)
                            .font(.caption)
                    }
                    Text(time)
                        .font(.custom("Outfit-Medium", size: 10))
                        .foregroundColor(.gray)
                }
            }
            Spacer()
            Image(systemName: "ellipsis")
                .foregroundColor(.gray)
        }
     }
  }

struct ReplyBubble: View {
    let reply: ReviewReply

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image("People2")
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(reply.authorName)
                        .font(.custom("Outfit-Medium", size: 13))
                        .foregroundColor(.black)
                    Text(reply.role)
                        .font(.custom("Outfit-Medium", size: 10))
                        .foregroundColor(Color(hex: "#258694"))
                    Spacer()
                    Text(reply.time)
                        .font(.custom("Outfit-Regular", size: 10))
                        .foregroundColor(.gray)
                }
                Text(reply.text)
                    .font(.custom("Outfit-Regular", size: 12))
                    .foregroundColor(.black)
            }
            .padding(10)
            .background(Color(hex: "#E9F6F8"))
            .cornerRadius(8)
        }
        .padding(.leading, 40)
    }
}

struct ReplyEditor: View {
    @Binding var replyText: String
    var onSend: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            TextField("Write a reply...", text: $replyText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.custom("Outfit-Regular", size: 12))
            Button("Send", action: onSend)
                .font(.custom("Outfit-Medium", size: 12))
                .buttonStyle(.borderedProminent)
        }
    }
}

struct StarsView: View {
    let rating: Double
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<5, id: \.self) { i in
                Image(systemName: i < Int(floor(rating)) ? "star.fill" : "star")
                    .foregroundColor(.orange)
                    .font(.caption)
            }
        }
    }
}
