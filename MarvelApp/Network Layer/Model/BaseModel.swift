//
//  BaseModel.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import Foundation

struct BaseModel<T: Codable>: Codable {
    var data: T?
    let result: String
    let code: Int
    let timestamp: String
    let message: String?
    let totalPages: Int?
}

struct TokenModel: Codable {
    let token: String
}
