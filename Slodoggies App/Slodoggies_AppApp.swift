//
//  Slodoggies_AppApp.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 11/07/25.
//

import SwiftUI

@main
struct Slodoggies_AppApp: App {
    let persistenceController = PersistenceController.shared
    @StateObject private var coordinator: Coordinator = Coordinator()
    @StateObject var userData = UserData()
    @StateObject var tabRouter = TabRouter()
    @StateObject var verificationData = verifiedData()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        UITextField.swizzleAddToolbar()
        UITextView.swizzleAddToolbar()
    }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .preferredColorScheme(.light) // Always Light Mode
                .environmentObject(self.coordinator)
                .environmentObject(userData)
                .environmentObject(tabRouter)
                .environmentObject(verificationData)
                .buttonStyle(NoEffectButtonStyle())
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

extension UITextField {
    static func swizzleAddToolbar() {
        let original = class_getInstanceMethod(self, #selector(becomeFirstResponder))
        let swizzled = class_getInstanceMethod(self, #selector(swizzled_becomeFirstResponder))
        if let original = original, let swizzled = swizzled {
            method_exchangeImplementations(original, swizzled)
        }
    }

    @objc private func swizzled_becomeFirstResponder() -> Bool {
        self.addDoneButtonOnKeyboard()
        return swizzled_becomeFirstResponder()
    }
}

extension UITextView {
    static func swizzleAddToolbar() {
        let original = class_getInstanceMethod(self, #selector(becomeFirstResponder))
        let swizzled = class_getInstanceMethod(self, #selector(swizzled_becomeFirstResponder))
        if let original = original, let swizzled = swizzled {
            method_exchangeImplementations(original, swizzled)
        }
    }

    @objc private func swizzled_becomeFirstResponder() -> Bool {
        self.addDoneButtonOnKeyboard()
        return swizzled_becomeFirstResponder()
    }
}
