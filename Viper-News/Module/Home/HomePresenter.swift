//
//  HomePresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation

protocol HomePresenterProtocol {
    func viewDidLoad()
    func getIndexSource(index: Int) -> Source?
    func numberOfItems() -> Int?
}

final class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    var sources: [Source] = []
    
    init(view: HomeViewControllerProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

extension HomePresenter: HomePresenterProtocol {
    
    func getIndexSource(index: Int) -> Source? {
        return sources[index]
    }
    
    func viewDidLoad() {
        view?.setupTableView()
        view?.showLoadingView()
        interactor.fetchSourcesData()
    }
    
    func numberOfItems() -> Int? {
        sources.count
    }
}


extension HomePresenter: HomeInteractorOutputProtocol {
    func fetchSourcesDataOutput(result: Result<NewsSourcesResponse, any Error>) {
        view?.hideLoadingView()
        switch result {
        case .success(let data):
            sources = data.sources ?? []
            view?.reloadData()
        case .failure(_):
            //TODO: data alınamadı uyarısı
            break
        }
    }
}
