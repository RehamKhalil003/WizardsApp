//
//  ElixirDetails.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import Foundation

// MARK: - Elixir
struct Elixir: Codable, Hashable {
    let id, name: String?
}

// MARK: - ElixirDetails
struct ElixirDetails: Codable, Hashable {
    let id, name, effect, sideEffects: String?
    let characteristics: String?
    let time: String?
    let difficulty: String?
    let ingredients: [Ingredient]?
    let inventors: [Inventor]?
    let manufacturer: String?
}

// MARK: - Ingredient
struct Ingredient: Codable, Hashable {
    let id, name: String?
}

// MARK: - Inventor
struct Inventor: Codable, Hashable {
    let id, firstName, lastName: String?
}
