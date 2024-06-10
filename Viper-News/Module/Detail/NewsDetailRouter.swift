//
//  NewsDetailRouter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation
import UIKit.UIApplication

protocol NewsDetailRouterProtocol: AnyObject {
    func navigate(_ route: DetailRoutes)
}

enum DetailRoutes {
    case openUrl(url: URL)
}


final class NewsDetailRouter {
    weak var viewController: NewsDetailViewController?
    
    static func createModule() -> NewsDetailViewController {
        let view = NewsDetailViewController()
        let interactor = NewsDetailInteractor()
        let router = NewsDetailRouter()
        let presenter = NewsDetailPresenter(view: view, interactor: interactor, router: router)
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        return view
    }
}


extension NewsDetailRouter: NewsDetailRouterProtocol {
    func navigate(_ route: DetailRoutes) {
        switch route {
        case .openUrl(let url):
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
