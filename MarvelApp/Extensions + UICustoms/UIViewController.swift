//
//  UIViewController.swift
//  Masar
//
//  Created by Mohamed Ali on 16/10/2024.
//

import UIKit
import SwiftUI

extension UIViewController {
    
    func hideTabBar() {
        tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func showTabBar() {
        tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
    }
    
    func showAlert(title: String,describition: String, completion: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
            completion()
        }))
        
        self.present(alert, animated: true)
    }
    
    func showAlert(title: String,describition: String) {
        let alert = UIAlertController(title: title, message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    func showSuccessAlert(describition: String,completion: @escaping () -> ()) {
        let alert = UIAlertController(title: "Success", message: describition, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default,handler: { _ in
            completion()
        }))
        
        self.present(alert, animated: true)
    }
    
    func dismissScreen() {
        navigationController?.popViewController(animated: true)
    }
}
