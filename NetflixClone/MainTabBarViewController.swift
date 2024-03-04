//
//  MainTabBarViewController.swift
//  NetflixClone
//
//  Created by ömer şanlı on 27.02.2024.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let vc1 = UINavigationController(rootViewController: HomeViewController(service: MoviesService()))
        let vc2 = UINavigationController(rootViewController: UpcomingViewController(service: MoviesService(), youtubeService: YoutubeService()))
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: DownloadsViewController())

        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")

        vc1.title = "Home"
        vc2.title = "Upcoming"
        vc3.title = "Search"
        vc4.title = "Downloads"

        tabBar.tintColor = .white

        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
    }
}
