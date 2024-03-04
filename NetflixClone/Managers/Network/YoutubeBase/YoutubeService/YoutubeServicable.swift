//
//  YoutubeServicable.swift
//  NetflixClone
//
//  Created by ömer şanlı on 4.03.2024.
//

import Foundation

protocol YoutubeServiceable {
    func getYoutubeVideoSearch(string: String) async -> Result<VideoElement, RequestError>

}

struct YoutubeService: HTTPClient, YoutubeServiceable {
    func getYoutubeVideoSearch(string: String) async -> Result<VideoElement, RequestError> {
        return await sendRequest(endpoint: YouTubeEndpoint.videoSearch(query: string), responseModel: VideoElement.self)
    }

}
