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

protocol DetailCellDelegate: AnyObject {
    func removeFromReadingList(url: String)
}

extension DetailsCellPresenter {
    fileprivate enum Constants {
        static let addListTitle = "➕Add 📋 "
        static let removeFromListTitle = "➖Remove"
    }
}

final class DetailsCellPresenter {
    var article: Article
    var view: DetailsCellProtocol
    var saved = savedNews()
    weak var delegate: DetailCellDelegate?
    
    init(article: Article, view: DetailsCellProtocol, delegate: DetailCellDelegate) {
        self.article = article
        self.view = view
        self.delegate = delegate
    }
    
}

extension DetailsCellPresenter: DetailsCellPresenterProtocol {
 
    func load() {
        view.setTitle(title: article.title ?? "")
        view.setDetail(detail: article.description ?? "")
        view.setImage(imageUrlString: article.urlToImage ?? "")
        guard let url = article.url else { return }
        saved.getNewsToSavedList { list in
            if list.contains(where: { $0.url == url}) {
                article.isAddedReadingList = true
            }
            let title = article.isAddedReadingList ? Constants.removeFromListTitle : Constants.addListTitle
            view.setButton(buttonTitle: title)
        }
    }
    
    
    //TODO: kayıt/çıkartma işlemi bitene kadar buton isimlerini değiştirmeyip load gösterebiliriz
    func saveList() {
        if article.isAddedReadingList {
            guard !(article.readingListEntity.url ?? "").isEmpty else { return }
            article.isAddedReadingList = false
            view.setButton(buttonTitle: Constants.addListTitle)
            saved.removeNewsFromSavedList(article.readingListEntity)
            delegate?.removeFromReadingList(url: article.readingListEntity.url ?? "")
            
        } else {
            guard !(article.readingListEntity.url ?? "").isEmpty else { return }
            article.isAddedReadingList = true
            view.setButton(buttonTitle: Constants.removeFromListTitle)
            saved.addNewsToSaveList(article.readingListEntity)
        }
    }
    
}
