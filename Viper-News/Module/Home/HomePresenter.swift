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
    func searchResult(text: String)
}

final class HomePresenter {
    weak var view: HomeViewControllerProtocol?
    let interactor: HomeInteractorProtocol
    let router: HomeRouterProtocol
    var sources: [Source] = []
    var filteredSources: [Source] = []
    
    init(view: HomeViewControllerProtocol, interactor: HomeInteractorProtocol, router: HomeRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
}

extension HomePresenter: HomePresenterProtocol {

    func getIndexSource(index: Int) -> Source? {
        return filteredSources[index]
    }
    
    func viewDidLoad() {
        view?.setupTableView()
        view?.setupSearchBar()
        view?.showLoadingView()
        interactor.fetchSourcesData()
    }
    
    func numberOfItems() -> Int? {
        filteredSources.count
    }
    
    func searchResult(text: String) {
        guard text.count != 0 else {
            filteredSources = sources
            return
        }
        let uppercasedText = text.uppercased()
        let filteredSources = sources.filter { source in
            let isContainInName = source.name?.uppercased().contains(uppercasedText) ?? false
            let isContainInDescription = source.description?.uppercased().contains(uppercasedText) ?? false
            return (isContainInName || isContainInDescription)
        }
        self.filteredSources = filteredSources
        view?.reloadData()
    }
}

extension HomePresenter: HomeInteractorOutputProtocol {
    func fetchSourcesDataOutput(result: Result<NewsSourcesResponse, any Error>) {
        view?.hideLoadingView()
        switch result {
        case .success(let data):
            sources = data.sources ?? []
            filteredSources = sources
            view?.reloadData()
        case .failure(_):
            //TODO: data alınamadı uyarısı
            break
        }
    }
}
