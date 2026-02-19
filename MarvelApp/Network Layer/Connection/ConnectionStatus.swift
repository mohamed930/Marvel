//
//  CheckConnection.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Combine
import Network

final class CheckConnection {
    enum ConnectionStatus {
        case unspecified
        case connected
        case disconnected
        case error
    }

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var connectionStatusPublisher = CurrentValueSubject<ConnectionStatus, Never>(.unspecified)
    private var checkTimer: Timer?

    var connectionStatusObservable: AnyPublisher<ConnectionStatus, Never> {
        connectionStatusPublisher.eraseToAnyPublisher()
    }

    init() {
        print("✅ NWPathMonitor started")

        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }

            if path.status == .satisfied {
                // Path exists — now confirm real internet
                self.verifyInternetReachable()
            } else {
                print("🚫 No network path")
                self.connectionStatusPublisher.send(.disconnected)
            }
        }

        monitor.start(queue: queue)
    }

    private func verifyInternetReachable() {
        // Check using a quick HEAD request
        guard let url = URL(string: "https://www.google.com/generate_204") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 3

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Internet check failed:", error.localizedDescription)
                self.connectionStatusPublisher.send(.disconnected)
                return
            }

            if let httpResponse = response as? HTTPURLResponse,
               (200...299).contains(httpResponse.statusCode) {
                print("🌐 Internet reachable (HTTP \(httpResponse.statusCode))")
                self.connectionStatusPublisher.send(.connected)
            } else {
                print("⚠️ Internet not reachable (bad status)")
                self.connectionStatusPublisher.send(.disconnected)
            }
        }.resume()
    }
}


