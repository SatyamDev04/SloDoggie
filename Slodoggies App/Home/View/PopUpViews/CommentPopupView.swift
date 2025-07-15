//
//  CommentPopupView.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 15/07/25.
//


import SwiftUI

struct CommentPopupView: View {
//    @Environment(\.dismiss) var dismiss
    @State private var commentText: String = ""
    
    var body: some View {
        ZStack{
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 0) {
                // Header
                HStack{
                    Spacer()
                    Button(action: {
                        //                        backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.top)
                .padding(.horizontal)
                VStack(alignment: .leading, spacing: 24){
                    Text("Tell us about your pet!")
                        .font(.custom("Outfit-Medium", size: 18))
                        .padding(.bottom, 4)
                    
                    Divider()
                    
                    ScrollView {
                        VStack() {
                            CommentRowView(profileImage: "profile1", name: "Dianne Russell", role: "Pet Mom", time: "24 min", text: "This place is amazing! My dog loved it", likeCount: 2, isReply: false)
                            
                            CommentRowView(profileImage: "profile1", name: "Albert Russell", role: "Pet Mom", time: "24 min", text: "Amazing", likeCount: 2, isReply: true)
                            
                            CommentRowView(profileImage: "profile2", name: "Jack Roger", role: "Pet Dad", time: "1 day ago", text: "Took my pup here last weekend — 10/10 would recommend! 🐕", likeCount: 1, isReply: false)
                        }
                        .padding()
                    }
                    
                    // Text Field Input
                    HStack {
                        TextField("Type your comment here", text: $commentText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(20)
                        
                        Button {
                            print("Send tapped")
                        } label: {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color(hex: "#258694"))
                                .clipShape(Circle())
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(20)
                .frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
    }
}
struct CommentRowView: View {
    var profileImage: String
    var name: String
    var role: String
    var time: String
    var text: String
    var likeCount: Int
    var isReply: Bool = false

    var body: some View {
        HStack(alignment: .top) {
            Image(profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .padding(.leading, isReply ? 36 : 0)

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(name).bold()
                    Text(role)
                        .font(.caption2)
                        .padding(4)
                        .background(Color(hex: "#E6F4F1"))
                        .cornerRadius(4)
                    Spacer()
                    Text(time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text(text)
                    .font(.body)

                HStack(spacing: 8) {
                    Button("Reply") {}
                        .font(.caption)
                        .foregroundColor(Color(hex: "#258694"))

                    HStack(spacing: 4) {
                        Image(systemName: "pawprint")
                        Text("\(likeCount)")
                    }
                    .font(.caption)
                    .foregroundColor(Color(hex: "#258694"))
                }
            }

            Spacer()

            Button {
                print("More tapped")
            } label: {
                Image(systemName: "ellipsis")
                    .rotationEffect(.degrees(90))
                    .foregroundColor(.gray)
            }
        }
    }
}
#Preview {
    CommentPopupView()
}
