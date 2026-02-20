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
    
    func moveToCharactersListScreen() {
        coordinator?.moveToCharactersScreen()
    }
    
    func moveToDetailsInSafariScreen() {
        let urlString = "https://www.marvel.com"
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
