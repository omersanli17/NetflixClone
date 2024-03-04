//
//  YoutubeEndpoint.swift
//  NetflixClone
//
//  Created by ömer şanlı on 4.03.2024.
//

import Foundation

enum YouTubeEndpoint {
    case videoSearch(query: String)
    case videoDetails(videoId: String)
}

extension YouTubeEndpoint: Endpoint {
    var header: [String: String]? {
        return nil
    }

    var body: [String: String]? {
        return nil
    }

    var host: String {
        return "www.googleapis.com"
    }
    var path: String {
        switch self {
        case .videoSearch(let query):
             let newQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            return "/youtube/v3/search?part=snippet&q=\(newQuery ?? query)&key=\(Constant.API.Google_ApiKey)"
        case .videoDetails(let videoId):
            return "/youtube/v3/videos/\(videoId)"
        }
        // Add other path configurations for additional endpoints
    }

    var method: RequestMethod {
        switch self {
        case .videoSearch, .videoDetails:
            return .get
        }
    }
}
