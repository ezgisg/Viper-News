//
//  SourcesCellPresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation

protocol SourcesCellPresenterProtocol: AnyObject {
    func setView()
}

final class SourcesCellPresenter {
    let view: SourcesCellProtocol?
    private let source: Source
    init(view: SourcesCellProtocol?, source: Source) {
        self.view = view
        self.source = source
    }
  
}

extension SourcesCellPresenter: SourcesCellPresenterProtocol {
    func setView() {
        view?.setTitle(title: source.name ?? "")
        view?.setDescription(description: source.description ?? "")
    }
    
}
