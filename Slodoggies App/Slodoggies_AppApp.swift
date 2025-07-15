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
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .environmentObject(self.coordinator)
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
