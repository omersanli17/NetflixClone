//
//  MoviesEndpoint.swift
//  NetflixClone
//
//  Created by ömer şanlı on 1.03.2024.
//

import Foundation

enum MoviesEndpoint {
    case topRated
    case movieDetail(id: Int)
    case trendingMovies
    case popularMovies
    case trendingTv
    case upcomingMovies
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .topRated:
            return "/3/movie/top_rated"
        case .movieDetail(let id):
            return "/3/movie/\(id)"
        case .trendingMovies:
            return "/3/trending/movie/day"
        case .trendingTv:
            return "/3/trending/tv/day"
        case .upcomingMovies:
            return "/3/movie/upcoming"
        case .popularMovies:
            return "/3/movie/popular"
        }
    }

    var method: RequestMethod {
        switch self {
        case .topRated, .movieDetail, .trendingMovies, .trendingTv, .upcomingMovies, .popularMovies:
            return .get
        }
    }

    var header: [String: String]? {
        // Access Token to use in Bearer header
        let accessToken = Constant.API.API_KEY
        switch self {
        case .topRated, .movieDetail, .trendingTv, .upcomingMovies, .popularMovies, .trendingMovies:
            return [
                "Authorization": "Bearer \(accessToken)",
                "Content-Type": "application/json;charset=utf-8"
            ]
        }
    }

    var body: [String: String]? {
        switch self {
        case .topRated, .movieDetail, .trendingMovies, .trendingTv, .upcomingMovies, .popularMovies:
            return nil
        }
    }
}
