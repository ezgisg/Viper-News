//
//  SplashViewController.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import UIKit


protocol SplashViewControllerProtocol: AnyObject {
    func setImage(image: UIImage)
    func makeAlert(title: String, message: String)
    func sendLabel() -> UILabel
}

class SplashViewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var presenter: SplashPresenterProtocol?
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter?.viewDidAppear()
    }


}

extension SplashViewController: SplashViewControllerProtocol {
    func sendLabel() -> UILabel {
        return titleLabel
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    func makeAlert(title: String, message: String) {
        showAlert(title: title, message: message)
    }
}
