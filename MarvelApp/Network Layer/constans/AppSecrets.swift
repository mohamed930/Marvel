//
//  AppSecrets.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation

final class AppSecrets {
    static var marvelPublicKey: String? {
        value(for: "MARVEL_PUBLIC_KEY")
    }

    static var marvelPrivateKey: String? {
        value(for: "MARVEL_PRIVATE_KEY")
    }

    private static func value(for key: String) -> String? {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        else {
            return nil
        }

        return value
    }
}
