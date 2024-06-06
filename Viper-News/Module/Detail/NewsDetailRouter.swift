//
//  NewsDetailRouter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

protocol NewsDetailRouterProtocol: AnyObject {
    
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
    
}
