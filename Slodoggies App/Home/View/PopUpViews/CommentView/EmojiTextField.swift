//
//  EmojiTextField.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 06/01/26.
//



import SwiftUI

struct EmojiTextField: UIViewRepresentable {
    @Binding var text: String
    @Binding var isFirstResponder: Bool
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.isHidden = true
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if isFirstResponder {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: EmojiTextField
        init(_ parent: EmojiTextField) {
            self.parent = parent
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let range = Range(range, in: parent.text) {
                parent.text.replaceSubrange(range, with: string)
            } else {
                parent.text.append(string)
            }
            return false
        }
    }
}