//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by ömer şanlı on 28.02.2024.
//

import UIKit

class UpcomingViewController: UIViewController {

    private let service: MoviesServiceable
    private let youtubeService: YoutubeServiceable

    private var titles: [MovieModel] = [MovieModel]()

    private let upcomingTable: UITableView = {

        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    init(service: MoviesServiceable, youtubeService: YoutubeServiceable) {
        self.service = service
        self.youtubeService = youtubeService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self

        fetchUpcoming()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    private func fetchDataUpcomingMovies(completion: @escaping (Result<TopRatedModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getUpcomingMovies()
            completion(result)
        }
    }

    private func fetchMovieByID(id: Int, completion: @escaping (Result<MovieModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getMovieDetail(id: id)
            completion(result)
        }
    }

    private func fetchYoutubeByString(searchTerm: String, completion: @escaping (Result<VideoElement, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await youtubeService.getYoutubeVideoSearch(string: searchTerm)
            completion(result)
        }
    }

    private func fetchUpcoming() {
        fetchDataUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.titles = titles.results
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func getMovieUpcomingController() {
        fetchDataUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let titles):
                self.titles = titles.results
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }

            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    // NEW

    func fetchVideos(searchTerm: String, completion: @escaping (Result<[Video], Error>) -> Void) {
        let apiKey = Constant.API.Google_ApiKey // Replace with your YouTube Data API v3 key
      guard let url = URL(string: "https://www.googleapis.com/youtube/v3/search?part=snippet&q=\(searchTerm)&key=\(apiKey)") else {
        completion(.failure(NSError(domain: "InvalidURL", code: -1, userInfo: nil)))
        return
      }

      var urlRequest = URLRequest(url: url)
      urlRequest.httpMethod = "GET"

      let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        if let error = error {
          completion(.failure(error))
          return
        }

        guard let data = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
          completion(.failure(NSError(domain: "APIError", code: -2, userInfo: nil)))
          return
        }

        do {
          let decoder = JSONDecoder()
          let videoResponse = try decoder.decode(VideoResponse.self, from: data)
          completion(.success(videoResponse.items))
        } catch {
          completion(.failure(error))
        }
      }

      task.resume()
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }

        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.originalTitle ?? title.title) ?? "Unknown title name", posterURL: title.posterPath ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)

          let title = titles[indexPath.row]

        fetchVideos(searchTerm: title.title) { [weak self] result in
            switch result {
            case .success(let videos):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: Video(id: videos.first!.id, snippet: videos.first!.snippet))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let error):
                print("error")
            }
        }
      }

}

struct VideoResponse: Decodable {
  let items: [Video]
}

struct Video: Decodable {
  let id: VideoID
  let snippet: Snippet

  struct VideoID: Decodable {
    let kind: String
    let videoId: String
  }

  struct Snippet: Decodable {
    let title: String
    let description: String
  }
}
