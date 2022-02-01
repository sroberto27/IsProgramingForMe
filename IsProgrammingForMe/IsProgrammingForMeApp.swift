//
//  IsProgrammingForMeApp.swift
//  IsProgrammingForMe
//
//  Created by roberto salazar on 12/2/21.
//

import SwiftUI

@main
struct IsProgrammingForMeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
