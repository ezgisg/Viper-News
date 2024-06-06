//
//  SplashInteractor.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import Foundation


protocol SplashInteractorProtocol: AnyObject {
    func checkInternetConnection()
    
}

protocol SplashInteractorOutputProtocol: AnyObject {
    func checkInternetConnectionOutput(status: Bool)
}

final class SplashInteractor {
    var output: SplashInteractorOutputProtocol?
}

extension SplashInteractor: SplashInteractorProtocol {
    func checkInternetConnection() {
        let internetStatus = NetworkManager.shared.isConnectedToInternet()
        self.output?.checkInternetConnectionOutput(status: internetStatus)
    }
}
