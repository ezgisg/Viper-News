//
//  HomeInteractor.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation


protocol HomeInteractorProtocol {
    func fetchSourcesData()
}

protocol HomeInteractorOutputProtocol {
    func fetchSourcesDataOutput(result: Result<NewsSourcesResponse, Error>)
}

final class HomeInteractor {
    fileprivate let service : NewsService = NewsService()
    var output: HomeInteractorOutputProtocol?
}

extension HomeInteractor: HomeInteractorProtocol {
    func fetchSourcesData() {
        service.fetchNewsSources { [weak self] sourcesResult in
            guard let self else { return }
            self.output?.fetchSourcesDataOutput(result: sourcesResult)
        }
    }
    
}
