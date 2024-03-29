//
//  TopRated.swift
//  NetflixClone
//
//  Created by ömer şanlı on 1.03.2024.
//

import Foundation

struct TopRatedModel: Codable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results: [MovieModel]

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
