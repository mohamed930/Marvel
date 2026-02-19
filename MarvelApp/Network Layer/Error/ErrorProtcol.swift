//
//  ErrorProtcol.swift
//  Morizone
//
//  Created by Mohamed Ali on 06/11/2025.
//


import Foundation
import Combine

protocol ErrorProtcol {
    func handleError(error: Subscribers.Completion<NSError>) -> errorMessage?
    func sendAuthFaild() -> errorMessage
}


extension ErrorProtcol {
    
    func handleError(error: Subscribers.Completion<NSError>) -> errorMessage? {
        switch error {
           case .finished: break
           case .failure(let err):
           let e = err.userInfo[NSLocalizedDescriptionKey] as? String ?? ""
           print("F: \(e)")
            
            if e == "Error in your connection" {
                let model = errorMessage(type: .connection, message: "Error in your connection")
                return model
            }
            else {
                let model = errorMessage(type: .anyThing, message: e)
                return model
            }
        }
        
        return nil
    }
    
    func sendAuthFaild() -> errorMessage {
        return errorMessage(type: .unauthorization, message: "Login Again")
    }
}
