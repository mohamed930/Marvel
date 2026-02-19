//
//  CharactersRepository.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation
import Combine

final class CharactersRepository: CharactersRepositoryProtocol {
    private let remoteDataSource: HomeAPIProtocol

    init(remoteDataSource: HomeAPIProtocol = HomeAPI()) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchCharacters(limit: Int = 20, offset: Int = 0) -> AnyPublisher<[CharacterEntity], NSError> {
        remoteDataSource.fetchCharacters(limit: limit, offset: offset)
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
