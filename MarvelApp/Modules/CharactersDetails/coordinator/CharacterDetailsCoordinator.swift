//
//  CharacterDetailsCoordinator.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import UIKit

class CharacterDetailsCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
            
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewmodel = CharacterDetailsViewModel()
        viewmodel.coordinator = self
        let viewController = CharacterDetailsViewController(viewmodel: viewmodel)
        viewController.viewmodel = viewmodel
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func moveToCharactersScreen() {
        navigationController.popViewController(animated: true)
    }
}
