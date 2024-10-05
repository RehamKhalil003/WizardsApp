//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//
import SwiftUI
import Swinject

@main
struct WizardsAppApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            WizardContentView()
                .environment(\.managedObjectContext,
                              CoreDataHelper.shared.persistentContainer.viewContext)
        }
    }
}
