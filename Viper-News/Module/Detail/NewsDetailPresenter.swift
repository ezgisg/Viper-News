//
//  NewsDetailPresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

protocol NewsDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func getArticle(index: Int) -> Article?
    func numberOfItems() -> Int
}

final class NewsDetailPresenter {
    weak var view: NewsDetailViewControllerProtocol?
    let interactor: NewsDetailInteractorProtocol
    let router: NewsDetailRouterProtocol
    var detailresponses: NewsDetailResponse? 
    
    init(view: NewsDetailViewControllerProtocol, interactor: NewsDetailInteractorProtocol, router: NewsDetailRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}

extension NewsDetailPresenter: NewsDetailPresenterProtocol {

    func viewDidLoad() {
        guard let source = view?.getSource() else { return }
        interactor.fetchDetails(sourceID: source.id ?? "", page: 1, query: nil)
    }
    
    func getArticle(index: Int) -> Article? {
        detailresponses?.articles?[safe: index]
    }
    
    func numberOfItems() -> Int {
        return detailresponses?.articles?.count ?? 0
    }
    
}

extension NewsDetailPresenter: NewsDetailInteractorOutputProtocol {
    func fetchDetailsOutput(result: NewsDetailResult) {
        switch result {
        case .success(let details):
            detailresponses = details
            view?.reloadData()
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
    
}

