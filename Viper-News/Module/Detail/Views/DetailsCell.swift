//
//  DetailsCell.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import UIKit
import Kingfisher

protocol DetailsCellProtocol {
    func setImage(imageUrlString: String)
    func setTitle(title: String)
    func setDetail(detail: String)
    func setButton(buttonTitle: String)

}

class DetailsCell: UITableViewCell {

    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var addListButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var cellPresenter: DetailsCellPresenterProtocol? {
        didSet {
            cellPresenter?.load()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func tapAddListButton(_ sender: Any) {
        cellPresenter?.saveList()
    }
}

extension DetailsCell: DetailsCellProtocol {

    internal func setImage(imageUrlString: String) {
        let url = URL(string: imageUrlString)
        detailImage.kf.indicatorType = .activity
        detailImage.contentMode = .scaleAspectFill
        detailImage.layer.cornerRadius = 10
        detailImage.kf.setImage(with: url) { result in
            switch result {
            case .success(let data):
                self.detailImage.image = data.image
            case .failure(let error):
                print("Görüntü yüklenirken hata oluştu: \(error.localizedDescription)")
                self.detailImage.image = UIImage(named: "noImage")
            }
        }
    }

    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setDetail(detail: String) {
        detailLabel.text = detail
    }
    
    func setButton(buttonTitle: String) {
        addListButton.setTitle(buttonTitle, for: .normal)
    }
    
    
}

