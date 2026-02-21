//
//  GetCharactersUseCase.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation
import Combine

protocol GetCharactersUseCaseProtocol {
    func execute(limit: Int, offset: Int) -> AnyPublisher<[CharacterEntity], NSError>
    func executeResult(at index: Int) -> ResultModel
}

final class GetCharactersUseCase: GetCharactersUseCaseProtocol {
    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func execute(limit: Int = 20, offset: Int = 0) -> AnyPublisher<[CharacterEntity], NSError> {
        repository.fetchCharacters(limit: limit, offset: offset)
            .eraseToAnyPublisher()
    }

    func executeResult(at index: Int) -> ResultModel {
        repository.fetchCharacterResult(at: index)
    }
}
