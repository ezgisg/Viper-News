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
    func loadMoreData()
    func isAllPagesFetched() -> Bool
    func fetchDataWithSearchText(text: String)
}

final class NewsDetailPresenter {
    weak var view: NewsDetailViewControllerProtocol?
    let interactor: NewsDetailInteractorProtocol
    let router: NewsDetailRouterProtocol
    var detailresponses: [NewsDetailResponse]? 
    var articles: [Article] = []
    var searchedArticles: [Article] = []
    var articlesToShow: [Article] = []
    
    
    //TODO: current page yerine sorgudan dönen totalresult ile kıyaslayarak ilerlenebilir
    var currentPage = 1
    var isLoading = false
    var didFetchedAllPages = false
    var isSearch = false
    
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
        articlesToShow[safe: index]
    }
    
    func numberOfItems() -> Int {
        return articlesToShow.count
    }
    
    func loadMoreData() {
        guard !isLoading else { return }
        currentPage += 1
        isLoading = true
        guard let source = view?.getSource() else { return }
        interactor.fetchDetails(sourceID: source.id ?? "", page: currentPage, query: nil)
    }
    
    func isAllPagesFetched() -> Bool {
         self.didFetchedAllPages
    }
    
    func fetchDataWithSearchText(text: String) {
        guard text.count != 0 else {
            articlesToShow = articles
            return }
        isSearch = true
        guard let source = view?.getSource() else { return }
        interactor.fetchDetails(sourceID: source.id ?? "", page: nil, query: text)
    }
    
    
}

extension NewsDetailPresenter: NewsDetailInteractorOutputProtocol {
    func fetchDetailsOutput(result: NewsDetailResult) {
        isLoading = false
        switch result {
        case .success(let details):
            if !isSearch {
                guard (details.articles?.count ?? 0) > 0 else {
                    didFetchedAllPages = true
                    return
                }
                articles.append(contentsOf: details.articles ?? [])
                articlesToShow = articles
            } else {
                searchedArticles.removeAll(keepingCapacity: false)
                searchedArticles.append(contentsOf: details.articles ?? [])
                articlesToShow = searchedArticles
                isSearch = false
            }
            view?.reloadData()
        case .failure(let error):
            //TODO: alert
            print("***Detay datayı çekerken hata oluştu \(error)")
        }
    }
    
}

