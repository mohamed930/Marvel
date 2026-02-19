//
//  BaseModel.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 15/02/2024.
//

import Foundation

// MARK: - BaseModel
struct BaseModel<T: Codable>: Codable {
    let code: Int
    let status: String
    let copyright: String?
    let attributionText: String?
    let attributionHTML: String?
    let etag: String?
    let data: DataContainer<T>
}

// MARK: - DataContainer
struct DataContainer<T: Codable>: Codable {
    let offset: Int
    let limit: Int
    let total: Int
    let count: Int
    let results: T
}

