//
//  DoneToolbarTextField.swift
//  Slodoggies App
//
//  Created by YES IT Labs on 18/09/25.
//

import SwiftUI
import UIKit

extension UIView {
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self,
                                         action: #selector(UIView.dismissKeyboard))

        toolbar.items = [flexSpace, doneButton]
        toolbar.isUserInteractionEnabled = true

        if let textField = self as? UITextField {
            textField.inputAccessoryView = toolbar
        } else if let textView = self as? UITextView {
            textView.inputAccessoryView = toolbar
        }
    }

    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
