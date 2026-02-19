//
//  Api.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Combine

// currentUrl: https://dafterq.lnj.sa/
// Quality: https://dafterq.lnj.sa/
// Production: https://dafterp.lnj.sa/

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
            return "https://morizon.sherifshalaby.tech/api/v1/"
        case .fetchCharacters:
            return "https://geocode-api.arcgis.com/arcgis/rest/services/World/"
        }
    }
}
