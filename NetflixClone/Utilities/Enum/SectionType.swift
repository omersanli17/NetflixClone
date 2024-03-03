//
//  SectionType.swift
//  NetflixClone
//
//  Created by ömer şanlı on 2.03.2024.
//

import Foundation

enum SectionTitle: Int, CaseIterable {
    case trendingMovies
    case popular
    case topRated
    case upcomingMovies

    var desciption: String {
        switch self {
        case .trendingMovies:
            "Trending Movies"
        case .popular:
            "Popular"
        case .topRated:
            "Top Rated"
        case .upcomingMovies:
            "Upcoming Movies"
        }
    }
}
