//
//  WizardsAppApp.swift
//  WizardsApp
//
//  Created by Reham Khalil on 02/10/2024.
//

import Foundation
import Combine

class WizardRepository {
    private var cancellables = Set<AnyCancellable>()

    func fetchWizardList(completion: @escaping (Result<[Wizard], Error>) -> Void) {
        guard let url = URL(string: "https://wizard-world-api.herokuapp.com/Wizards") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
                return
            }

            do {
                let wizardList = try JSONDecoder().decode([Wizard].self, from: data)
                completion(.success(wizardList))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func fetchElixirsList(for wizardId: String, completion: @escaping (Result<Wizard, Error>) -> Void) {
        guard let url = URL(string: "https://wizard-world-api.herokuapp.com/Wizards/\(wizardId)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "DataError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data returned."])))
                return
            }

            do {
                let wizard = try JSONDecoder().decode(Wizard.self, from: data)
                completion(.success(wizard))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }

    func getElixirsDetails(for elixirsId: String) -> AnyPublisher<ElixirDetails, Error> {
        guard let url = URL(string: "https://wizard-world-api.herokuapp.com/Elixirs/\(elixirsId)") else {
            return Fail(error: NSError(domain: "URL Error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ElixirDetails.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
