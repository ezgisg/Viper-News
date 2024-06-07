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
    func setupSearchBar()
    func reloadData()
    func setTitle(title: String)
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
        setupSearchBar()
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
    
    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setTitle(title: String) {
        self.title = title
    }
    
}


//TODO: hiçbir haber yoksa (numberofitems 0 ise) boş view oluşturalım
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
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !(presenter?.isAllPagesFetched() ?? true) else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            presenter?.loadMoreData()
        }
    }
}

extension NewsDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.fetchDataWithSearchText(text: searchText)
    }
    
}
