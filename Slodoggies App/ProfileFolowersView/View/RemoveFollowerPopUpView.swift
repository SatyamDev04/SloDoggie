//
//  RemoveFollowerPopUpView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 21/07/25.
//

import SwiftUI
 
struct RemoveFollowerPopUp: View {
    @Binding var isVisible: Bool
    var tabType: FollowersViewModel.Tab
    var backAction : () -> () = {}
    var onRemove: () -> Void = {}
 
    var body: some View {
        ZStack {
            // Background dimming
            Color(hex: "#3C3C434A").opacity(0.5)
                .ignoresSafeArea()
 
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isVisible = false
                        backAction()
                    }) {
                        Image("CancelIcon")
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                }
                .padding(.top)
                .padding(.trailing, 45)
 
                VStack(spacing: 20) {
                    Image("RemoveUser")
                        .scaledToFit()
                        .frame(width: 50, height: 50)
 
                    // Conditional title
                    Text(tabType == .followers ? "Remove Follower?" : "Are you sure you want to unfollow \(selectedUserNamePlaceholder())?")
                        .font(.custom("Outfit-Medium", size: 17))
                        .multilineTextAlignment(.center)
                    
                    // Conditional message
                    Text(tabType == .followers
                         ? "We won’t tell \(selectedUserNamePlaceholder()) they were removed from your followers."
                         : "You’ll stop seeing their updates and posts in your feed — but don’t worry, they won’t be notified.")
                        .font(.custom("Outfit-Regular", size: 15))
                        .multilineTextAlignment(.center)
 
                    HStack {
                        Button("Cancel") {
                            isVisible = false
                        }
                        .font(.custom("Outfit-Medium", size: 16))
                        .foregroundColor(.black)
                        .padding()
                        .frame(width: 144, height: 42)
 
                        Button(tabType == .followers ? "Remove" : "Unfollow") {
                            isVisible = false
                            onRemove()
                        }
                        .padding()
                        .frame(width: 140, height: 42)
                        .font(.custom("Outfit-Bold", size: 15))
                        .foregroundColor(.white)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal, 10)
                .frame(width: 320)
                .padding(.vertical)
                .background(Color.white)
                .cornerRadius(20)
            }
        }
    }
 
    private func selectedUserNamePlaceholder() -> String {
        // You can later replace this placeholder logic by passing actual user name
        return "this user"
    }
}
 
#Preview {
    RemoveFollowerPopUp(isVisible: .constant(true), tabType: .followers)
}

