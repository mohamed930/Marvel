//
//  LocalStorage.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import Foundation

protocol LocalStorageKeysProtocol {
    var rawValue: String { get }
}

protocol Storeable {
    var storeData: Data? { get }
    init?(storeData: Data?)
}

extension Storeable where Self: Codable {
    
    var storeData: Data? {
        try? JSONEncoder().encode(self)
    }
    
    init?(storeData: Data?) {
        guard let storeData else { return nil }
        guard let decoded = try? JSONDecoder().decode(Self.self, from: storeData) else { return nil }
        self = decoded
    }
}

protocol LocalStorageProtocol {
    func value<T>(key: LocalStorageKeysProtocol) -> T?
    func write<T>(key: LocalStorageKeysProtocol, value: T?)
    func remove(key: LocalStorageKeysProtocol)
    
    func valueStoreable<T>(key: LocalStorageKeysProtocol) -> T? where T: Storeable
    func writeStoreable<T>(key: LocalStorageKeysProtocol, value: T?) where T: Storeable
}

enum LocalStorageKeys: String, LocalStorageKeysProtocol {
    case token
    case fullName
    case avatar
    case email
    case accountType
    case driverProfile
    case isLogin
}


class LocalStorage: LocalStorageProtocol {
    fileprivate let userDefaults: UserDefaults = UserDefaults.standard
    
    func value<T>(key: LocalStorageKeysProtocol) -> T? {
        return self.userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func write<T>(key: LocalStorageKeysProtocol, value: T?) {
        self.userDefaults.set(value, forKey: key.rawValue)
    }
    
    func remove(key: LocalStorageKeysProtocol) {
        self.userDefaults.set(nil, forKey: key.rawValue)
    }
    
    func valueStoreable<T>(key: LocalStorageKeysProtocol) -> T? where T: Storeable {
        let data: Data? = self.userDefaults.data(forKey: key.rawValue)
        return T(storeData: data)
    }
    
    func writeStoreable<T>(key: LocalStorageKeysProtocol, value: T?) where T: Storeable {
        self.userDefaults.set(value?.storeData, forKey: key.rawValue)
    }
}
