//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import Foundation
import Combine

class ElixirViewModel: ObservableObject {
    @Published var elixirs: [Elixir] = []
    @Published var elixirDetails: ElixirDetails? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let repository: WizardRepository
    private var cancellables = Set<AnyCancellable>()

    init(repository: WizardRepository = WizardRepository()) {
        self.repository = repository
    }

    func getElixirsList(for wizardID: String, completion: @escaping () -> Void) {
        isLoading = true 
        repository.fetchElixirsList(for: wizardID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let wizard):
                    self?.elixirs = wizard.elixirs ?? []
                    print(wizard)
                case .failure(let error):
                    print("Something went wrong 🤬 \(error)")
                    self?.errorMessage = "Failed to load elixirs: \(error.localizedDescription)"
                }
                self?.isLoading = false
                completion()
            }
        }
    }

    func getElixirDetails(for id: String) {
        isLoading = true // Start loading
        repository.getElixirsDetails(for: id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Failed to fetch elixir details: \(error)")
                    self?.errorMessage = "Failed to load elixir details: \(error.localizedDescription)"
                }
                self?.isLoading = false // End loading
            }, receiveValue: { [weak self] elixir in
                self?.elixirDetails = elixir
            })
            .store(in: &cancellables)
    }

}
