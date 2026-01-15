//
//  ChatView.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 17/07/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showMenu = false
    @State private var showDeletePopup = false
    @State private var showReportPopup = false
    @State private var showBusiReportPopup = false
    @State private var isBlocked = false
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    @EnvironmentObject private var coordinator: Coordinator

    // MARK: - Present Attachment Options
    private func presentAttachmentOptions() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }

        let alert = UIAlertController(title: "Select Attachment", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Photo", style: .default) { _ in
            showImagePicker = true
        })
        alert.addAction(UIAlertAction(title: "Document (PDF)", style: .default) { _ in
            showDocumentPicker = true
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        rootVC.present(alert, animated: true)
    }

    // MARK: - View Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // MARK: Header
                HStack(spacing: 12) {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image("Back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }

                    Image("ChatProfile")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Jane Cooper")
                            .font(.headline)
                            .foregroundColor(.black)

                        HStack(spacing: 12) {
                            Image("OnlineDot")
                                .resizable()
                                .frame(width: 8, height: 8)
                                .clipShape(Circle())
                            Text("Active Now")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }

                    Spacer()

                    Button(action: {
                        withAnimation { showMenu.toggle() }
                    }) {
                        Image("ThreeDots")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.trailing, 10)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color.white)
                .shadow(color: .gray.opacity(0.1), radius: 1)

                Divider()

                // MARK: Chat List
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in

                                // Day Separator
                                if index == 0 || !Calendar.current.isDate(message.timestamp, inSameDayAs: viewModel.messages[index-1].timestamp) {
                                    Text(message.timestamp, formatter: dayDateFormatter)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 8)
                                        .id("date_\(index)")
                                }

                                ChatBubbleView(
                                    message: message,
                                    isCurrentUser: message.userId == viewModel.currentUserId
                                )
                                .id(message.id)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        if let last = viewModel.messages.last {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }

                // MARK: Input Area
                if isBlocked {
                    Button(action: { isBlocked = false }) {
                        Text("Unblock ‘Jane’")
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color(hex: "#258694"))
                            .cornerRadius(8)
                    }
                    .padding(.vertical, 12)
                } else {
                    HStack(spacing: 8) {
                        HStack {
                            Button(action: {
                                presentAttachmentOptions()
                            }) {
                                Image("paperclip")
                                    .foregroundColor(.gray)
                            }

                            TextField("Type something", text: $viewModel.newMessage)
                                .foregroundColor(.black)
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .frame(height: 50)
                        .background(Color(red: 0/255, green: 99/255, blue: 121/255, opacity: 0.1))
                        .cornerRadius(10)

                        Button(action: {
                            viewModel.sendMessage()
                        }) {
                            Image("sendmsg")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color.white)
                }
            }

            // MARK: Sheets
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker { image in
//                    print("Picked image:", image)
//                    viewModel.addImageMessage(image)
//                }
//            }
//            .sheet(isPresented: $showDocumentPicker) {
//                DocumentPicker { fileURL in
//                    print("Picked document:", fileURL)
//                    viewModel.addDocumentMessage(fileURL)
//                }
//            }

            // MARK: Popup Menu
            .overlay(alignment: .topTrailing) {
                if showMenu {
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation { showMenu = false }
                        }

                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: {
                            showMenu = false
                            showDeletePopup = true
                        }) {
                            Label("Delete", image: "delete")
                                .foregroundColor(.black)
                        }

                        Button(action: {
                            showMenu = false
                            let userType = UserDefaults.standard.string(forKey: "userType")
                            if userType == "Professional" {
                                showReportPopup = true
                            } else {
                                showReportPopup = true
                            }
                        }) {
                            Label("Report User", image: "report")
                                .foregroundColor(.black)
                        }

                        Button(action: {
                            showMenu = false
                            isBlocked = true
                        }) {
                            Label("Block User", image: "block")
                                .foregroundColor(.black)
                        }

                        Label("Give Feedback", image: "feedback")
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(width: 200, alignment: .leading)
                    .position(x: UIScreen.main.bounds.width - 115, y: 140)
                }
            }
        }

        // MARK: Overlays
        .overlay {
            if showDeletePopup {
                DeleteChatPopUpView(isPresented: $showDeletePopup)
                    .transition(.opacity)
                    .ignoresSafeArea()
            }
        }

        .overlay {
            if showReportPopup {
                ReportUserBottomSheetView(reportOn: "ChatComment", isPresented: $showReportPopup)
                    .transition(.opacity)
            }
        }

        .overlay {
            if showBusiReportPopup {
                BusiReportUserPopUpView(isPresented: $showBusiReportPopup, reportOn: "BusiComment")
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - Date Formatter
let dayDateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var onPicked: (URL) -> Void

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf])
        picker.allowsMultipleSelection = false
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        init(_ parent: DocumentPicker) { self.parent = parent }

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.presentationMode.wrappedValue.dismiss()
            if let url = urls.first {
                parent.onPicked(url)
            }
        }

        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ChatView()
        .environmentObject(Coordinator())
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ChatView()
            }
        }
    }
}
