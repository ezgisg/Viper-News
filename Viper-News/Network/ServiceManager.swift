//
//  ServiceManager.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation

protocol NewsServiceProtocol {
    func fetchNewsSources(completion: @escaping (NewsSourcesResult) -> ())
    func fetchDetail(sourceID: String, page: Int?, query: String?, completion: @escaping (NewsDetailResult) -> ())
}

class NewsService: NewsServiceProtocol {
    func fetchNewsSources(completion: @escaping (NewsSourcesResult) -> ()) {
        NetworkManager.shared.request(Router.sources, decodeToType: NewsSourcesResponse.self, completion: completion)
    }
    
    func fetchDetail(sourceID: String, page: Int?, query: String?, completion: @escaping (NewsDetailResult) -> ()) {
        NetworkManager.shared.request(Router.everything(source: sourceID, page: page, query: query), decodeToType: NewsDetailResponse.self, completion: completion)
    }
    
    
}

typealias NewsSourcesResult = Result<NewsSourcesResponse, Error>
typealias NewsDetailResult = Result<NewsDetailResponse, Error>
