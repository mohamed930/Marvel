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
    let modified: String
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

// MARK: - MockupModel.
extension ResultModel {

    static let mock: ResultModel = .init(
        id: 1011334,
        name: "3-D Man",
        description: "3-D Man possesses superhuman strength, speed, and durability. He is able to perceive things in three dimensions beyond normal human capability.",
        modified: "2014-04-29T14:18:17-0400",
        thumbnail: .mock,
        resourceURI: "http://gateway.marvel.com/v1/public/characters/1011334",
        comics: .mockComics,
        series: .mockSeries,
        stories: .mockStories,
        events: .mockEvents,
        urls: [.mock]
    )
    
    static let mockNoDescription: ResultModel = {
        var model = ResultModel.mock
        return ResultModel(
            id: model.id,
            name: model.name,
            description: "",
            modified: model.modified,
            thumbnail: model.thumbnail,
            resourceURI: model.resourceURI,
            comics: model.comics,
            series: model.series,
            stories: model.stories,
            events: model.events,
            urls: model.urls
        )
    }()
    
    static let mockEmptySections = ResultModel(
        id: 999,
        name: "Test Hero",
        description: "Testing empty sections UI.",
        modified: "2024-01-01",
        thumbnail: .mock,
        resourceURI: "",
        comics: .empty,
        series: .empty,
        stories: .empty,
        events: .empty,
        urls: [.mock]
    )
}

extension Thumbnail {
    static let mock = Thumbnail(
        path: "https://i.annihil.us/u/prod/marvel/i/mg/6/70/52602f21b4b0a",
        thumbnailExtension: "jpg"
    )
}

extension Item {
    static let mock = Item(
        resourceURI: "http://gateway.marvel.com/v1/public/comics/21366",
        name: "Avengers: The Initiative (2007) #14"
    )
}

extension Comics {

    static let mockComics = Comics(
        available: 12,
        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/comics",
        items: [.mock, .mock, .mock],
        returned: 3
    )

    static let mockSeries = Comics(
        available: 3,
        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/series",
        items: [.mock, .mock],
        returned: 2
    )

    static let mockStories = Comics(
        available: 21,
        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/stories",
        items: [.mock],
        returned: 1
    )

    static let mockEvents = Comics(
        available: 1,
        collectionURI: "http://gateway.marvel.com/v1/public/characters/1011334/events",
        items: [.mock],
        returned: 1
    )

    /// Empty version (VERY useful for testing hide logic)
    static let empty = Comics(
        available: 0,
        collectionURI: "",
        items: [],
        returned: 0
    )
}

extension URLElement {
    static let mock = URLElement(
        type: "detail",
        url: "http://marvel.com/characters/74/3-d_man"
    )
}
