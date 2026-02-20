//
//  CharactersRepository.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation
import Combine

enum CharactersRepositoryMode {
    case remote
    case mock
}

final class CharactersRepository: CharactersRepositoryProtocol {
    private let remoteDataSource: HomeAPIProtocol
    private let mockCharacters: [CharacterEntity]
    private let mode: CharactersRepositoryMode

    init(
        remoteDataSource: HomeAPIProtocol = HomeAPI(),
        mockCharacters: [CharacterEntity] = CharacterEntity.mockData,
        mode: CharactersRepositoryMode = .remote
    ) {
        self.remoteDataSource = remoteDataSource
        self.mockCharacters = mockCharacters
        self.mode = mode
    }

    func fetchCharacters(limit: Int = 20, offset: Int = 0) -> AnyPublisher<[CharacterEntity], NSError> {
        switch mode {
        case .mock:
            return paginatedMockCharacters(limit: limit, offset: offset)
        case .remote:
            return remoteDataSource.fetchCharacters(limit: limit, offset: offset)
                .map { response in
                    response.data.results.map { result in
                        CharacterEntity(
                            id: result.id,
                            name: result.name,
                            description: result.description,
                            thumbnailURL: "\(result.thumbnail.path).\(result.thumbnail.thumbnailExtension)"
                        )
                    }
                }
                .eraseToAnyPublisher()
        }
    }
    
    private func paginatedMockCharacters(limit: Int, offset: Int) -> AnyPublisher<[CharacterEntity], NSError> {
        let endIndex = min(offset + limit, mockCharacters.count)
        let page = offset < endIndex ? Array(mockCharacters[offset..<endIndex]) : []
        
        return Just(page)
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }
}
