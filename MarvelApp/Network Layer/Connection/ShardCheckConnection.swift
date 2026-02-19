//
//  ShardCheckConnection.swift
//  testConnection
//
//  Created by Mohamed Ali on 20/01/2024.
//

import Foundation
import Combine

final class ShardCheckConnection {
    static let shared = ShardCheckConnection()
    private let connection = CheckConnection()

    var connectionStatusObservable: AnyPublisher<CheckConnection.ConnectionStatus, Never> {
        connection.connectionStatusObservable
    }

    private init() {
        print("🔌 ShardCheckConnection initialized")
    }
}
