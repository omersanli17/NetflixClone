//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by ömer şanlı on 28.02.2024.
//

import UIKit

class UpcomingViewController: UIViewController {

    private let service: MoviesServiceable

    private var titles: [MovieModel] = [MovieModel]()

    private let upcomingTable: UITableView = {

        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    init(service: MoviesServiceable) {
        self.service = service
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

}
