//
//  SplashRouter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation
import UIKit

protocol SplashRouterProtocol: AnyObject {
    func navigate(_ route: SplashRoutes)
}

enum SplashRoutes {
    case homeScreen
    case tabBar
}


final class SplashRouter {
    
    weak var viewController: SplashViewController?
    
    static func createModule() -> SplashViewController {
        let view = SplashViewController()
        let interactor = SplashInteractor()
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view, router: router, interactor: interactor)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
    
}

extension SplashRouter: SplashRouterProtocol {
    func navigate(_ route: SplashRoutes) {
        switch route {
        case .homeScreen:
            guard let window = viewController?.view.window else { return }
            let homeVC = HomeRouter.createModule()
            let navigationController = UINavigationController(rootViewController: homeVC )
            window.rootViewController = navigationController
        case .tabBar:
            guard let window = viewController?.view.window else { return }
            let tabBarController = TabBarController()
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
