//
//  CharactersViewModel.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation
import Combine

class CharactersViewModel {
    var coordinator: CharactersCoordinator?
    private let pageLimit = 20
    private var hasMorePages = true
    private static let repositoryMode: CharactersRepositoryMode = .mock
    
    private var charactersPublisher = CurrentValueSubject<[CharacterEntity], Never>([])
    var charactersObservable: AnyPublisher<[CharacterEntity],Never> {
        return charactersPublisher.eraseToAnyPublisher()
    }
    var characters: [CharacterEntity] {
        charactersPublisher.value
    }
    var errorMessagePublisher = PassthroughSubject<String?,Never>()
    
    var pagaignLoadingBehaviour = CurrentValueSubject<Bool,Never>(false)
    
    private let getCharactersUseCase: GetCharactersUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        getCharactersUseCase: GetCharactersUseCaseProtocol = GetCharactersUseCase(
            repository: CharactersRepository(mode: CharactersViewModel.repositoryMode)
        )
    ) {
        self.getCharactersUseCase = getCharactersUseCase
    }
    
    func moveToCharacterDetails(index: Int) {
        
    }
    
    func fetchCharacters() {
        getCharactersUseCase.execute(limit: pageLimit, offset: 0)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessagePublisher.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] characters in
                guard let self = self else { return }
                
                self.charactersPublisher.send(characters)
                self.hasMorePages = characters.count == self.pageLimit
            }
            .store(in: &cancellables)
    }
    
    func fetchNextPageOperation() {
        guard hasMorePages else { return }
        
        pagaignLoadingBehaviour.send(true)
        let nextOffset = characters.count
        
        getCharactersUseCase.execute(limit: pageLimit, offset: nextOffset)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.pagaignLoadingBehaviour.send(false)
                
                switch completion {
                case .finished: break
                case .failure(let error):
                    self.errorMessagePublisher.send(error.localizedDescription)
                }
            } receiveValue: { [weak self] nextPageCharacters in
                guard let self = self else { return }
                
                guard !nextPageCharacters.isEmpty else {
                    self.hasMorePages = false
                    return
                }
                
                self.charactersPublisher.send(self.characters + nextPageCharacters)
                self.hasMorePages = nextPageCharacters.count == self.pageLimit
            }
            .store(in: &cancellables)
    }
}
