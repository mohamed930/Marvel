//
//  CharacterEntity+Mock.swift
//  MarvelApp
//
//  Created by Codex on 20/02/2026.
//

import Foundation

extension CharacterEntity {
    static let mockData: [CharacterEntity] = (1...50).map { index in
        CharacterEntity(
            id: index,
            name: "Mock Hero \(index)",
            description: "This is mock description for character \(index).",
            thumbnailURL: "https://via.placeholder.com/300x300?text=Hero+\(index)"
        )
    }
}
