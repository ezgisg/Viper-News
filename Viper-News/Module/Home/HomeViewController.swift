//
//  HomeViewController.swift
//  Viper-News
//
//  Created by Ezgi Sümer Günaydın on 5.06.2024.
//

import UIKit

protocol HomeViewControllerProtocol: AnyObject {
    func setTitle(title: String)
    func setupTableView()
    func reloadData()
    func showLoadingView()
    func hideLoadingView()
    func setupSearchBar()
}

class HomeViewController: BaseViewController, LoadingShowable {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var presenter: HomePresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }
    
}

extension HomeViewController: HomeViewControllerProtocol {
  

    func setTitle(title: String) {
        self.title = title
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(cellType: SourcesCell.self)
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func showLoadingView() {
        showLoading()
    }
    
    func hideLoadingView() {
        hideLoading()
    }
    
    func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Ara"
    }
    
}


extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SourcesCell.self, for: indexPath)
        if let source = presenter?.getIndexSource(index: indexPath.row) {
            cell.cellPresenter = SourcesCellPresenter(view: cell, source: source)
        }
        return cell
    }
    
    
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectRow(index: indexPath.row)
    }
}


extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter?.searchResult(text: searchText)
    }
}
