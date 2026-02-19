//
//  ResultModel.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import Foundation

// MARK: - Result
struct ResultModel: Codable {
    let id: Int
    let name, description: String
    let modified: Date
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series, stories, events: Comics
    let urls: [URLElement]
}

// MARK: - Comics
struct Comics: Codable {
    let available: Int
    let collectionURI: String
    let items: [Item]
    let returned: Int
}

// MARK: - Item
struct Item: Codable {
    let resourceURI: String
    let name: String
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let thumbnailExtension: String

    enum CodingKeys: String, CodingKey {
        case path
        case thumbnailExtension = "extension"
    }
}

// MARK: - URLElement
struct URLElement: Codable {
    let type: String
    let url: String
}
