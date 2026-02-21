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
    private var cachedResults: [ResultModel] = []

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

        remoteDataSource.fetchCharacters(limit: limit, offset: offset)
            .map { [weak self] response in
                guard let self = self else { return [] }
                
                let results = response.data.results
                cachedResults = results
                
                return results.map { result in
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
    
    private func paginatedMockCharacters(limit: Int, offset: Int) -> AnyPublisher<[CharacterEntity], NSError> {
        let endIndex = min(offset + limit, mockCharacters.count)
        let page = offset < endIndex ? Array(mockCharacters[offset..<endIndex]) : []
        
        return Just(page)
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }

    func fetchCharacterResult(at index: Int) -> ResultModel {
        guard cachedResults.indices.contains(index) else {
            preconditionFailure("Character index \(index) is out of bounds. Fetch characters first and use a valid index.")
        }
        return cachedResults[index]
    }
}
