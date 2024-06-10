//
//  NewsDetailPresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

protocol NewsDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func getArticle(index: Int) -> Article?
    func numberOfItems() -> Int
    func loadMoreData()
    func isAllPagesFetched() -> Bool
    func fetchDataWithSearchText(text: String)
    func updateReadingList(url: String)
    func tappedRow(_ index: Int)
}

final class NewsDetailPresenter {
    weak var view: NewsDetailViewControllerProtocol?
    let interactor: NewsDetailInteractorProtocol
    let router: NewsDetailRouterProtocol
    var detailresponses: [NewsDetailResponse]? 
    var articles: [Article] = []
    var searchedArticles: [Article] = []
    var articlesToShow: [Article] = []
    var saved = savedNews()
    
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

    func viewWillAppear() {
        getAllSavedArticles()
    }
    
    
    func viewDidLoad() {
        guard let source = view?.getSource() else { return }
        interactor.fetchDetails(sourceID: source.id ?? "", page: 1, query: nil)
        view?.setTitle(title: "All News")
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
            view?.reloadData()
            return }
        isSearch = true
        guard let source = view?.getSource() else { return }
        interactor.fetchDetails(sourceID: source.id ?? "", page: nil, query: text)
    }
    
    func getAllSavedArticles() {
        guard view?.isReadingList == true else { return }
        saved.getNewsToSavedList { list in
            articlesToShow.removeAll(keepingCapacity: false)
            list.forEach { readingListNews in
                let article = Article(
                          source: ArticleSource(id: nil, name: nil),
                          author: nil,
                          title: readingListNews.title,
                          description: readingListNews.description,
                          url: readingListNews.url,
                          urlToImage: readingListNews.urlToImage,
                          publishedAt: nil,
                          content: nil,
                          isAddedReadingList: true,
                          readingListEntity: readingListNews
                      )
                articlesToShow.append(article)
            }
            view?.reloadData()
        }
    }
    
    func updateReadingList(url: String) {
        guard view?.isReadingList == true else { return }
        let index = articlesToShow.firstIndex { $0.url == url }
        guard let index else { return }
        articlesToShow.remove(at: index)
        view?.reloadData()
    }
    
    func tappedRow(_ index: Int) {
        let urlString = articlesToShow[index].url
        if let urlString,
           let url = URL(string: urlString) {
            router.navigate(.openUrl(url: url))
        }
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

