//
//  NewsDetailViewController.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 6.06.2024.
//

import UIKit

protocol NewsDetailViewControllerProtocol: AnyObject {
    var isReadingList: Bool {get set}
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
    private var _isReadingList: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        setupTableview()
        setupSearchBar()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        presenter?.viewWillAppear()
        reloadData()
    }
    
}

extension NewsDetailViewController: NewsDetailViewControllerProtocol {
    var isReadingList: Bool {
          get {
              return _isReadingList
          }
          set {
              _isReadingList = newValue
          }
      }
    
  
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
        if isReadingList {
            let searchBarHeightConstraint = searchBar.heightAnchor.constraint(equalToConstant: 0)
            searchBarHeightConstraint.isActive = true
            searchBar.isHidden = true
        }
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
            cell.cellPresenter = DetailsCellPresenter(article: article, view: cell, delegate: self)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.3, animations: {
            tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.3) {
                tableView.cellForRow(at: indexPath)?.transform = CGAffineTransform.identity
            } completion: { _ in
                self.presenter?.tappedRow(indexPath.row)
            }
        })
    }
}

extension NewsDetailViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.fetchDataWithSearchText(text: searchText)
    }
    
}

extension NewsDetailViewController: DetailCellDelegate {
    func removeFromReadingList(url: String) {
        presenter?.updateReadingList(url: url)
    }
    
}
