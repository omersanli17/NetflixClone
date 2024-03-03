//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by ömer şanlı on 28.02.2024.
//

import UIKit

class HomeViewController: UIViewController {

    private let service: MoviesServiceable

    private(set) var trendingMovies: [MovieModel] = []
    private(set) var popularMovies: [MovieModel] = []
    private(set) var topRated: [MovieModel] = []
    private(set) var upcomingMovies: [MovieModel] = []

    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
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
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)

        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self

        configureNavBar()

        let headerView = HeroHeaderUIView(frame: .init(x: 0, y: 0, width: view.bounds.width, height: 450))
        homeFeedTable.tableHeaderView = headerView

        loadTableView()
    }

    private func showModal(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func fetchDataTrendingMovies(completion: @escaping (Result<TopRatedModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getTrendingMovie()
            completion(result)
        }
    }

    private func fetchDataPopularMovies(completion: @escaping (Result<TopRatedModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getPopularMovies()
            completion(result)
        }
    }

    private func fetchDataTopRated(completion: @escaping (Result<TopRatedModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getTopRated()
            completion(result)
        }
    }

    private func fetchDataUpcomingMovies(completion: @escaping (Result<TopRatedModel, RequestError>) -> Void) {
        Task(priority: .background) {
            let result = await service.getUpcomingMovies()
            completion(result)
        }
    }

    func loadTableView(completion: (() -> Void)? = nil) {

        fetchDataTrendingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.trendingMovies = response.results
                self.homeFeedTable.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }

        fetchDataPopularMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.popularMovies = response.results
                self.homeFeedTable.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }

        fetchDataTopRated { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.topRated = response.results
                self.homeFeedTable.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }

        fetchDataUpcomingMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.upcomingMovies = response.results
                self.homeFeedTable.reloadData()
                completion?()
            case .failure(let error):
                self.showModal(title: "Error", message: error.customMessage)
                completion?()
            }
        }
    }

    private func configureNavBar() {
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)

        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .init(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: .init(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionTitle.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section {
        case SectionTitle.trendingMovies.rawValue:
            cell.configure(with: trendingMovies)
        case SectionTitle.popular.rawValue:
            cell.configure(with: popularMovies)
        case SectionTitle.topRated.rawValue:
            cell.configure(with: topRated)
        case SectionTitle.upcomingMovies.rawValue:
            cell.configure(with: upcomingMovies)
        default:
            cell.configure(with: trendingMovies)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionTitle = SectionTitle(rawValue: section) else {
            return nil
        }
        return sectionTitle.desciption
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }

}
