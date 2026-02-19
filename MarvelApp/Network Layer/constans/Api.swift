//
//  Api.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Combine

struct errorMessage {
    let type: errorStatus
    let message: String
    var operation: String = ""
}


enum errorStatus {
    case connection
    case anyThing
    case validation
    case unauthorization
}

enum Api {
    case baseUrl
    case fetchCharacters
}

extension Api {
    
    var rawValue: String {
        switch self {
        case .baseUrl:
            return "https://gateway.marvel.com"
        case .fetchCharacters:
            return "/v1/public/characters"
        }
    }
}
