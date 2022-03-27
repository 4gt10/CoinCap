//
//  SettingsIconViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import UIKit

final class SettingsIconViewController: UIViewController {
    @IBOutlet private weak var tableVIew: UITableView!
    private lazy var dataControlleer = SettingsIconDataController(onSelected: { [weak self] in
        self?.tableVIew.reloadData()
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension SettingsIconViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataControlleer.selectedItem(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private
private extension SettingsIconViewController {
    func setup() {
        title = R.string.localizable.settingsIconTitle()
        
        tableVIew.dataSource = dataControlleer
    }
}
