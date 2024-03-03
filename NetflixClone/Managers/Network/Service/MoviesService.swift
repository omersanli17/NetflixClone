//
//  MoviesService.swift
//  NetflixClone
//
//  Created by ömer şanlı on 1.03.2024.
//

import Foundation

protocol MoviesServiceable {
    func getTopRated() async -> Result<TopRatedModel, RequestError>
    func getMovieDetail(id: Int) async -> Result<MovieModel, RequestError>
    func getUpcomingMovies() async -> Result<TopRatedModel, RequestError>
    func getPopularMovies() async -> Result<TopRatedModel, RequestError>
    func getTrendingMovie() async -> Result<TopRatedModel, RequestError>
}

struct MoviesService: HTTPClient, MoviesServiceable {

    func getTrendingMovie() async -> Result<TopRatedModel, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.trendingMovies, responseModel: TopRatedModel.self)
    }

    func getPopularMovies() async -> Result<TopRatedModel, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.popularMovies, responseModel: TopRatedModel.self)
    }

    func getTopRated() async -> Result<TopRatedModel, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.topRated, responseModel: TopRatedModel.self)
    }

    func getUpcomingMovies() async -> Result<TopRatedModel, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.upcomingMovies, responseModel: TopRatedModel.self)
    }

    func getMovieDetail(id: Int) async -> Result<MovieModel, RequestError> {
        return await sendRequest(endpoint: MoviesEndpoint.movieDetail(id: id), responseModel: MovieModel.self)
    }
}
