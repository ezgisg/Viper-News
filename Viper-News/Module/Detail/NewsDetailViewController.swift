//
//  NewsDetailViewController.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import UIKit

protocol NewsDetailViewControllerProtocol: AnyObject {
    func getSource() -> Source?
    func setupTableview()
    func reloadData()
}

class NewsDetailViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: NewsDetailPresenterProtocol?
    var source: Source?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTableview()
    }

}

extension NewsDetailViewController: NewsDetailViewControllerProtocol {

    func setupTableview() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: DetailsCell.self)
    }
    
    func getSource() -> Source? {
        return source
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
}

extension NewsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: DetailsCell.self , for: indexPath)
        if let article = presenter?.getArticle(index: indexPath.row) {
        cell.cellPresenter = DetailsCellPresenter(article: article, view: cell)
        }
        return cell
    }
    
}

extension NewsDetailViewController: UITableViewDelegate {
    
}
