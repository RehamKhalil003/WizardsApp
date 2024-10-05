//
//  WizardModel.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import Foundation

// MARK: - WizardModel
struct Wizard: Codable, Hashable, Identifiable {
    let elixirs: [Elixir]?
    let id: String?
    let firstName: String?
    let lastName: String?

    // Computed property to provide the full name of the wizard
    var fullName: String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
}
