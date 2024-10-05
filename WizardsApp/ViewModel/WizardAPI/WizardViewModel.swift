//
//  ViewModel.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import SwiftUI
import Combine
import CoreData

class WizardViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    private var networkMonitor: NetworkMonitor = NetworkMonitor.shared
    
    @Published var wizards: [Wizard] = []
    @Published var isLoading: Bool = false
    @Published var toastMessage: String = ""
    @Published var showToast: Bool = false
    
    private let repository: WizardRepository

    init(repository: WizardRepository = WizardRepository(), context: NSManagedObjectContext) {
        self.repository = repository
        self.managedObjectContext = context
        
        networkMonitor.$isConnected.sink { [weak self] isConnected in
            if isConnected {
                self?.toastMessage = "You are online!"
            } else {
                self?.toastMessage = "You are offline!"
                self?.fetchWizards()
            }
            self?.showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self?.showToast = false
            }
        }.store(in: &cancellables)
        
        networkMonitor.onReconnect = { [weak self] in
            self?.refreshWizardList()
        }
    }

    private var cancellables = Set<AnyCancellable>()
    
    func refreshWizardList() {
        isLoading = true
        getWizardList {}
        isLoading = false
    }

    func getWizardList(completion: @escaping () -> Void) {
        isLoading = true
        if networkMonitor.isConnected {
            repository.fetchWizardList { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let wizards):
                        self?.wizards = wizards
                        self?.saveWizards(wizards: wizards)
                    case .failure(let error):
                        print("Something went wrong 🤬 \(error)")
                        self?.fetchWizards()
                    }
                    self?.isLoading = false
                    completion()
                }
            }
        } else {
            self.isLoading = false
            self.toastMessage = "You are offline!"
            self.showToast = true
            fetchWizards() 
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showToast = false
            }
            completion()
        }
    }

    func saveWizards(wizards: [Wizard]) {
        for wizardData in wizards {
            let wizard = WizardEntity(context: managedObjectContext)
            wizard.id = wizardData.id ?? UUID().uuidString
            wizard.firstName = wizardData.firstName
            wizard.lastName = wizardData.lastName

            if let elixirs = wizardData.elixirs {
                for elixirData in elixirs {
                    let elixir = ElixirEntity(context: managedObjectContext)
                    elixir.id = elixirData.id ?? UUID().uuidString
                    elixir.name = elixirData.name

                    wizard.addToElixirs(elixir)
                }
            }
        }

        do {
            try managedObjectContext.save()
            print("Wizards and elixirs saved successfully!")
        } catch {
            print("Failed to save wizards and elixirs: \(error.localizedDescription)")
        }
    }

    
    func fetchWizards() {
        let fetchRequest: NSFetchRequest<WizardEntity> = WizardEntity.fetchRequest()

        do {
            let wizardEntities = try managedObjectContext.fetch(fetchRequest)
            
            self.wizards = wizardEntities.map { wizardEntity in
                let elixirEntities = wizardEntity.elixirs as? Set<ElixirEntity> ?? Set()
                
                let elixirs = elixirEntities.compactMap { elixirEntity in
                    return Elixir(id: elixirEntity.id, name: elixirEntity.name)
                }

                return Wizard(
                    elixirs: Array(elixirs),
                    id: wizardEntity.id,
                    firstName: wizardEntity.firstName,
                    lastName: wizardEntity.lastName
                )
            }
            print(wizards)
        } catch {
            print("Failed to fetch wizards: \(error)")
        }
    }
}
