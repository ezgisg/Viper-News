//
//  SourcesCell.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import UIKit

protocol SourcesCellProtocol {
    func setTitle(title: String)
    func setDescription(description: String)
}

class SourcesCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    var cellPresenter: SourcesCellPresenterProtocol? {
        didSet {
            cellPresenter?.setView()
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension SourcesCell: SourcesCellProtocol {
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setDescription(description: String) {
        descriptionLabel.text = description
    }
}
