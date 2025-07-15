import SwiftUI

struct PetInfoPopupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var petName = ""
    @State private var petBreed = ""
    @State private var petAge = ""
    @State private var petBio = ""
    @State private var managedBy = "Pet Mom"
    @State private var showAgePicker = false
    @State private var showManagerPicker = false

    let petAges = ["1", "2", "3", "4", "5+"]
    let managerOptions = ["Pet Mom", "Pet Dad", "Guardian"]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .padding(10)
                        .background(Color.white)
                        .clipShape(Circle())
                }
            }

            Text("Tell us about your pet!")
                .font(.headline)
                .padding(.bottom, 4)

            Divider()

            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 80, height: 80)
                        .overlay(
                            Image(systemName: "person.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.black)
                        )

                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .padding(4)
                        .background(Color(hex: "#258694"))
                        .clipShape(Circle())
                        .offset(x: 5, y: 5)
                }
                Text("Add Photo")
                    .font(.subheadline)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.top)

            Group {
                CustomTextField(title: "Pet Name", placeholder: "Enter pet name", text: $petName)
                CustomTextField(title: "Pet Breed", placeholder: "Enter Breed", text: $petBreed)

                CustomDropdownField(title: "Pet Age", text: $petAge, isPickerPresented: $showAgePicker, options: petAges)
                CustomTextField(title: "Pet Bio", placeholder: "Enter Bio", text: $petBio)

                CustomDropdownField(title: "Managed By", text: $managedBy, isPickerPresented: $showManagerPicker, options: managerOptions)
            }

            HStack {
                Button("Skip") {
                    dismiss()
                }
                .foregroundColor(.black)

                Spacer()

                Button(action: {
                    // Save & Continue action
                }) {
                    Text("Save & Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(minWidth: 150)
                        .background(Color(hex: "#258694"))
                        .cornerRadius(8)
                }
            }
            .padding(.top)

        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .padding()
    }
}

// MARK: - Components

struct CustomTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)

            TextField(placeholder, text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.4)))
        }
    }
}

struct CustomDropdownField: View {
    let title: String
    @Binding var text: String
    @Binding var isPickerPresented: Bool
    let options: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.black)

            Button(action: {
                isPickerPresented.toggle()
            }) {
                HStack {
                    Text(text.isEmpty ? "Select" : text)
                        .foregroundColor(text.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 6).stroke(Color.gray.opacity(0.4)))
            }

            if isPickerPresented {
                Picker("", selection: $text) {
                    ForEach(options, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    PetInfoPopupView()
}
