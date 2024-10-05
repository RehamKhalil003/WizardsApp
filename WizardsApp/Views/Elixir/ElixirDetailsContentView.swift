//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import SwiftUI

struct ElixirDetailsContentView: View {
    @StateObject var elixirViewModel = ElixirViewModel()
    var elixirId: String

    var body: some View {
        BaseContentView(title: "Elixir Details") {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
               
                    Image("elixirImage 1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 350)
                        .background(Color.clear)

                    Text(elixirViewModel.elixirDetails?.name ?? "Unknown Elixir")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                    
                    customSeparator()

                    Text("Effect: \(elixirViewModel.elixirDetails?.effect ?? "N/A")")
                        .font(.body)
                        .foregroundColor(.gray)

                    customSeparator()

                    Text("Difficulty: \(elixirViewModel.elixirDetails?.difficulty ?? "N/A")")
                        .font(.body)
                        .foregroundColor(.gray)

                    customSeparator()

                    if let ingredients = elixirViewModel.elixirDetails?.ingredients, !ingredients.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Ingredients:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                            ForEach(ingredients, id: \.self) { ingredient in
                                Text("- \(ingredient.name ?? "Unknown")")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 8)

                        customSeparator(color: .white)
                    }

                    if let inventors = elixirViewModel.elixirDetails?.inventors, !inventors.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Inventors:")
                                .font(.headline)
                                .foregroundColor(.black)
                                .bold()
                            ForEach(inventors, id: \.self) { inventor in
                                Text("- \(inventor.firstName ?? "Unknown") \(inventor.lastName ?? "")")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                .background(Color.white)
            }
        }
        .onAppear {
            elixirViewModel.getElixirDetails(for: elixirId)
        }
    }
    private func customSeparator(color: Color = Color(UIColor.systemGray6)) -> some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(color)
            .padding(.leading, 23)
    }
}

