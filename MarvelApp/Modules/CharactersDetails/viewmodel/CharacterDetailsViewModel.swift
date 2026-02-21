//
//  CharacterDetailsViewModel.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import Foundation
import UIKit

class CharacterDetailsViewModel: ObservableObject {
    var coordinator: CharacterDetailsCoordinator?
    var characterModel: ResultModel
    
    init(characterModel: ResultModel) {
        self.characterModel = characterModel
    }
    
    func moveToCharactersListScreen() {
        coordinator?.moveToCharactersScreen()
    }
    
    func moveToDetailsInSafariScreen() {
        let urlString = characterModel.resourceURI
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
