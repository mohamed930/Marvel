//
//  CharactersCoordinator.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import UIKit

class CharactersCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
            
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewmodel = CharactersViewModel()
        viewmodel.coordinator = self
        let viewController = CharactersViewController(viewmodel: viewmodel)
        viewController.viewmodel = viewmodel
        navigationController.setViewControllers([viewController], animated: true)
    }
    
    func moveToCharacterDetails(characterDetails: ResultModel) {
        let coordinator = CharacterDetailsCoordinator(navigationController: navigationController, characterModel: characterDetails)
        add(coordinator: coordinator)
        coordinator.start()
    }
}
