//
//  AppCoordinator.swift
//  LNJ
//
//  Created by Mohamed Ali on 02/05/2023.
//

import UIKit


final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow?
    
    static let shared = AppCoordinator()
        
    init(window: UIWindow) {
        self.window = window
    }
    
    override init() {
        self.window = nil
    }
    
    override func start() {
        let navigationController = UINavigationController()
        
        
        
        guard let window = window else {
            return
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
    }
}
