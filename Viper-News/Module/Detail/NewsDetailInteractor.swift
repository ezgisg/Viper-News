//
//  NewsDetailInteractor.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

protocol NewsDetailInteractorProtocol: AnyObject {
    func fetchDetails(sourceID: String, page: Int, query: String?)
}

protocol NewsDetailInteractorOutputProtocol: AnyObject {
    func fetchDetailsOutput(result: NewsDetailResult)
}

final class NewsDetailInteractor {
    fileprivate let service : NewsService = NewsService()
    var output: NewsDetailInteractorOutputProtocol?
}

extension NewsDetailInteractor: NewsDetailInteractorProtocol {
    func fetchDetails(sourceID: String, page: Int, query: String?) {
        service.fetchDetail(sourceID: sourceID, page: page, query: query) { result in
            self.output?.fetchDetailsOutput(result: result)
        }
    }
}


