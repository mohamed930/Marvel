//
//  UINavigationController.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 11/03/2024.
//

import UIKit

extension UINavigationController {
    
   func isViewControllerExsist(ofClass: AnyClass, animated: Bool = true) -> UIViewController? {
       
      if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
          // popToViewController(vc, animated: animated)
          return vc
      }
       else {
           return nil
       }
   }
    
}
