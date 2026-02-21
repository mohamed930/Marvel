//
//  CharacterDetailsCoordinator.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import UIKit

class CharacterDetailsCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
    let characterModel: ResultModel
            
    init(navigationController: UINavigationController,characterModel: ResultModel) {
        self.navigationController = navigationController
        self.characterModel = characterModel
    }
    
    override func start() {
        let viewmodel = CharacterDetailsViewModel(characterModel: characterModel)
        viewmodel.coordinator = self
        let viewController = CharacterDetailsViewController(viewmodel: viewmodel)
        viewController.viewmodel = viewmodel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToCharactersScreen() {
        navigationController.popViewController(animated: true)
    }
}
