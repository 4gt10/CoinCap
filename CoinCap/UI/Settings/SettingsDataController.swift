//
//  SettingsDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation
import UIKit
import CoreData

final class SettingsDataController: NSObject {
    private let appIconService = AppIconService.shared
    private var items: [SettingsData]
    private var onUpdatedItemAtIndexPath: ((IndexPath) -> Void)?
    
    init(onUpdatedItemAtIndexPath: ((IndexPath) -> Void)?) {
        self.onUpdatedItemAtIndexPath = onUpdatedItemAtIndexPath
        items = [
            .icon(appIconService.current)
        ]
        
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(iconUpdated), name: .iconUpdated, object: nil)
    }
    
    func item(atIndexPath indexPath: IndexPath) -> SettingsData? {
        items[safe: indexPath.row]
    }
}

extension SettingsDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailCell, for: indexPath) else {
            return .init()
        }
        cell.configure(with: items[indexPath.row].detailItem)
        return cell
    }
}

// MARK: - Notifications handling
private extension SettingsDataController {
    @objc private func iconUpdated() {
        guard let settingsIconIndex = items.firstIndex(where: {
            if case SettingsData.icon(_) = $0 { return true } else { return false }
        }) else { return }
        items[settingsIconIndex] = .icon(appIconService.current)
        onUpdatedItemAtIndexPath?(.init(row: settingsIconIndex, section: 0))
    }
}
