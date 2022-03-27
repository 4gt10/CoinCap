//
//  SettingsViewController.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

final class SettingsViewController: UIViewController {
    @IBOutlet private weak var tableVIew: UITableView!
    
    private let dataController = SettingsDataController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: R.segue.settingsViewController.icon, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private
private extension SettingsViewController {
    func setup() {
        title = R.string.localizable.settingsTitle()
        
        tableVIew.dataSource = dataController
    }
}
