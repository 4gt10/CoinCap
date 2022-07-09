//
//  SettingsViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

final class SettingsViewController: UIViewController, Storyboarded {
    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var dataController = SettingsDataController(
        onUpdatedItemAtIndexPath: { [weak self] in
            self?.tableView.reloadRows(at: [$0], with: .none)
        }
    )
    
    weak var coordinator: SettingsCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = dataController.item(atIndexPath: indexPath) else { return }
        coordinator?.openSettings(item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private
private extension SettingsViewController {
    func setup() {
        title = R.string.localizable.settingsTitle()
        
        tableView.dataSource = dataController
    }
}
