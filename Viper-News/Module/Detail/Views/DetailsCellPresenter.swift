//
//  DetailsCellPresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import Foundation

protocol DetailsCellPresenterProtocol: AnyObject {
    func load()
    func saveList()
}

final class DetailsCellPresenter {
    var article: Article
    var view: DetailsCellProtocol
    var saved = savedNews()
    
    init(article: Article, view: DetailsCellProtocol) {
        self.article = article
        self.view = view
    }
    
}

extension DetailsCellPresenter: DetailsCellPresenterProtocol {
 
    func load() {
        view.setTitle(title: article.title ?? "")
        view.setDetail(detail: article.description ?? "")
        view.setImage(imageUrlString: article.urlToImage ?? "")
        guard let url = article.url else { return }
        saved.getNewsToSavedList { list in
            if list.contains(url)  {
                view.setButton(buttonTitle: "Okuma Listesinden Çıkart")
            } else {
                view.setButton(buttonTitle: "Okuma Listesine Ekle")
            }
        }
    }
    
    
    //TODO: kayıt/çıkartma işlemi bitene kadar buton isimlerini değiştirmeyip load gösterebiliriz
    func saveList() {
        if article.readingListStatus {
            guard let url = article.url else { return }
            article.readingListStatus = false
            view.setButton(buttonTitle: "Okuma Listesine Ekle")
            saved.removeNewsFromSavedList(url)
        } else {
            guard let url = article.url else { return }
            article.readingListStatus = true
            view.setButton(buttonTitle: "Okuma Listesinden Çıkart")
            saved.addNewsToSaveList(url)
        }
 
    }
    
}
