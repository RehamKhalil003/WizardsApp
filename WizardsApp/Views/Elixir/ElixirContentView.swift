//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import SwiftUI

struct ElixirContentView: View {
    @StateObject var elixirViewModel = ElixirViewModel()
    var wizardId: String
    var wizardName: String
    @State private var animatedItems: [Bool] = [] 
    @State private var isSheetPresented = false
    @State private var selectedElixirId: String?

    var body: some View {
        BaseContentView(showBackButton: false) {
            List {
                ForEach(elixirViewModel.elixirs.indices, id: \.self) { index in
                    Button(action: {
                        
                        selectedElixirId = elixirViewModel.elixirs[index].id ?? ""
                        isSheetPresented = true
                    }) {
                        CustomListCell(
                            imageName: "elixirImage",
                            text: elixirViewModel.elixirs[index].name ?? "",
                            destination: AnyView(ElixirDetailsContentView(elixirId: selectedElixirId ?? ""))
                        )
                        .offset(x: animatedItems.indices.contains(index) && animatedItems[index] ? 0 : UIScreen.main.bounds.width)
                        .animation(
                            .easeOut(duration: 0.5)
                            .delay(Double(index) * 0.1), value: animatedItems.indices.contains(index) ? animatedItems[index] : false
                        )
                        .onAppear {
                            if animatedItems.count < elixirViewModel.elixirs.count {
                                animatedItems.append(true)
                            }
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(PlainListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Elixir for \(wizardName)")
                        .font(.system(size: 25, weight: .bold))
                }
            }
        }
        .onAppear {
            elixirViewModel.getElixirsList(for: wizardId) {
                animatedItems = Array(repeating: false, count: elixirViewModel.elixirs.count)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    for index in elixirViewModel.elixirs.indices {
                        animatedItems[index] = true
                    }
                }
            }
        }
        .sheet(isPresented: $isSheetPresented) {
            if let elixirId = selectedElixirId {
                ElixirDetailsContentView(elixirId: elixirId)
            }
        }
    }
}
