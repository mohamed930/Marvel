//
//  CharactersRepositoryProtocol.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation
import Combine

protocol CharactersRepositoryProtocol {
    func fetchCharacters(limit: Int, offset: Int) -> AnyPublisher<[CharacterEntity], NSError>
    func fetchCharacterResult(at index: Int) -> ResultModel
}
