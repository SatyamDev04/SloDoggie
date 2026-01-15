//
//  EditPostView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 09/09/25.
//


import SwiftUI

struct EditPostView: View {

    @Binding var isPresented: Bool
    let post: MyPostItem
    var onSave: (String) -> Void

    @State private var postText: String
    @FocusState private var isEditorFocused: Bool

    // ✅ Initialize editable text from post
    init(
        isPresented: Binding<Bool>,
        post: MyPostItem,
        onSave: @escaping (String) -> Void
    ) {
        self._isPresented = isPresented
        self.post = post
        self.onSave = onSave
        _postText = State(initialValue: post.postTitle ?? "")
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            HStack {
                Button {
                    isPresented = false
                } label: {
                    Image("Back")
                        .resizable()
                        .frame(width: 24, height: 24)
                }

                Text("Edit Post")
                    .font(.custom("Outfit-Medium", size: 18))

                Spacer()

                Button {
                    onSave(postText)
                    isPresented = false
                } label: {
                    Image("RightCheckMark")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding()
            .background(Color.white)

            Divider()

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {

                    // MARK: - User Row
                    HStack(spacing: 8) {

                        Image("DummyIcon")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 4) {

                            HStack(spacing: 4) {
                                Text(post.getUserDetail?.name ?? "")
                                    .font(.custom("Outfit-Medium", size: 12))

                                Text("with")
                                    .font(.custom("Outfit-Regular", size: 12))

                                Text(post.getPetDetail?.pet_name ?? "")
                                    .font(.custom("Outfit-Medium", size: 12))
                            }

                            Text(post.time ?? "")
                                .font(.custom("Outfit-Regular", size: 12))
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    }

                    // MARK: - Post Image (LoadImage)
                    if let media = post.getPostMedia?.first?.mediaPath {
                        Image.loadImage(
                            media,
                            width: .infinity,
                            height: 250,
                            cornerRadius: 12,
                            contentMode: .fill
                        )
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                        .cornerRadius(12)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 5)
                )
                .padding()

                // MARK: - Editable Text
                VStack(alignment: .leading) {
                    TextEditor(text: $postText)
                        .font(.custom("Outfit-Regular", size: 14))
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(12)
                        .frame(minHeight: 120)
                        .focused($isEditorFocused)
                }
                .background(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.1), radius: 5)
                )
                .padding(.horizontal, 20)
            }
            .background(Color(hex: "#E5EFF2"))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isEditorFocused = true
                }
            }
        }
    }
}
