//
//  NetworkMonitor.swift
//  WizardsApp
//
//  Created by Reham Khalil on 04/10/2024.
//

import Network
import Combine
import CoreData

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool = false {
        didSet {
            if isConnected {
                onReconnect?()
            }
        }
    }
    
    var onReconnect: (() -> Void)?
    
    static let shared = NetworkMonitor()
    
    private init() {
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
