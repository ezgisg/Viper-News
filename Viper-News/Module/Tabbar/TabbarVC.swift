//
//  TabbarVC.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 7.06.2024.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
    }
    
    private func setupViewControllers() {
        // HomeViewController
        let homeViewController = HomeRouter.createModule()
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        // ReadingListViewController
        let readingListViewController = NewsDetailRouter.createModule()
        readingListViewController.isReadingList = true
        let readingListNavigationController = UINavigationController(rootViewController: readingListViewController)
        readingListNavigationController.tabBarItem = UITabBarItem(title: "Reading List", image: UIImage(systemName: "book"), tag: 1)
        
        viewControllers = [homeNavigationController, readingListNavigationController]
    }
}
