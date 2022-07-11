//
//  WatchlistViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

final class WatchlistViewController: AssetsViewController {
    @IBOutlet private weak var emptyView: UIStackView!
    @IBOutlet private weak var emptyTitleLabel: UILabel!
    @IBOutlet private weak var emptyDescriptionLabel: UILabel!
    
    var watchlistCoordinator: WatchlistCoordinator? {
        return coordinator as? WatchlistCoordinator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reload()
    }
    
    override func setup() {
        dataController.onLoaded = { [weak self] in
            self?.refreshControl.endRefreshing()
            self?.tableView.reloadData()
        }
        dataController.onError = { [weak self] error in
            self?.refreshControl.endRefreshing()
            self?.alertMessage(error.localizedDescription)
        }
        (dataController as? WatchListDataController)?.onDelete = { [weak self] in
            self?.reload()
        }
        
        title = R.string.localizable.watchlistTitle()
        
        tableView.refreshControl = refreshControl
        tableView.dataSource = dataController
        
        reload()
    }
    
    override func didRefresh() {
        reload()
    }
}

extension WatchlistViewController {
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        R.string.localizable.watchlistItemDeleteActionTitle()
    }
}

// MARK: - Private
private extension WatchlistViewController {
    func reload() {
        guard let dataController = dataController as? WatchListDataController else { return }
        tableView.isHidden = dataController.isEmpty
        emptyView.isHidden = !dataController.isEmpty
        dataController.reload()
    }
}
