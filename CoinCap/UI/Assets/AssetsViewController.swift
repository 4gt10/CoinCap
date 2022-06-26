//
//  AssetsViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

class AssetsViewController: UIViewController {
    @IBOutlet private(set) weak var tableView: UITableView!
    private(set) lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didRefresh), for: .valueChanged)
        return refreshControl
    }()
    private let searchController = UISearchController(searchResultsController: nil)
    private var debounceWorkItem: DispatchWorkItem?
    
    var dataController: AssetsDataController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let destination = segue.destination as? AssetDetailsViewController,
            let selectedIndexPath = tableView.indexPathForSelectedRow,
            let asset = dataController.item(at: selectedIndexPath) else {
            return
        }
        destination.setDataController(.init(asset: asset))
    }
    
    func setup() {
        dataController = AssetsDataController { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        } onError: { [weak self] error in
            self?.refreshControl.endRefreshing()
            self?.alertMessage(error.localizedDescription)
        }
        
        title = R.string.localizable.assetsTitle()
        
        tableView.refreshControl = refreshControl
        tableView.dataSource = dataController
        reload()
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = R.string.localizable.assetsSearchBarPlaceholder()
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    @objc func didRefresh() {
        searchController.searchBar.text = ""
        reload()
    }
}

extension AssetsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.assetsViewController.assetDetails, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        dataController.loadMoreIfNeeded(for: indexPath)
    }
}

extension AssetsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            return
        }
        
        self.debounceWorkItem?.cancel()
        self.debounceWorkItem = DispatchWorkItem { [weak self] in
            self?.reload(withQuery: query)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300), execute: self.debounceWorkItem!)
    }
}

extension AssetsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reload()
    }
}

// MARK: - Private
private extension AssetsViewController {
    func reload(withQuery query: String = "") {
        dataController.reload(withQuery: query)
    }
}
