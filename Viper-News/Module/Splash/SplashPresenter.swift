//
//  SplashPresenter.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation
import UIKit.UIImage

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}

extension SplashPresenter {
    fileprivate enum Constants {
        static let noConnectionTitle = "Internet yok"
        static let noConnectionMessage = "Lütfen bağlantınızı kontrol edin"
    }
}


final class SplashPresenter {
    unowned var view: SplashViewControllerProtocol!
    let router: SplashRouterProtocol!
    let interactor: SplashInteractorProtocol!
    
    var internetStatus = false
    
    init(view: SplashViewControllerProtocol, router: SplashRouterProtocol, interactor: SplashInteractorProtocol) {
        self.view = view
        self.router = router
        self.interactor = interactor
    }
}

extension SplashPresenter: SplashPresenterProtocol {
    func viewDidAppear() {
        interactor.checkInternetConnection()
        if let image = UIImage(named: "news") {
            view.setImage(image: image)
        }
        addGesture()
    }
    
    func addGesture() {
        let myLabel = view.sendLabel()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        myLabel.isUserInteractionEnabled = true
        myLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        if internetStatus {
//            router.navigate(.homeScreen)
            router.navigate(.tabBar)
        } else {
            view.makeAlert(title: Constants.noConnectionTitle, message: Constants.noConnectionMessage)
            interactor.checkInternetConnection()
    
        }

    }
}

extension SplashPresenter: SplashInteractorOutputProtocol {
    func checkInternetConnectionOutput(status: Bool) {
        if status {
            internetStatus = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self else { return }
                self.router.navigate(.tabBar)
                    }
        } else {
            internetStatus = false
            view.makeAlert(title: Constants.noConnectionTitle, message: Constants.noConnectionMessage)
        }
    }
}
