//
//  SettingsIconDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation
import UIKit

final class SettingsIconDataController: NSObject {
    private let appIconService = AppIconService()
    private var allIcons: [AppIconService.Icon] { appIconService.all }
    private var currentIcon: AppIconService.Icon { appIconService.current }
    private var onSelected: (() -> Void)?
    
    init(onSelected: (() -> Void)?) {
        self.onSelected = onSelected
    }
    
    func selectedItem(at indexPath: IndexPath) {
        guard let item = allIcons[safe: indexPath.row] else {
            return
        }
        appIconService.set(item)
        onSelected?()
    }
}

extension SettingsIconDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allIcons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailCell, for: indexPath),
            let icon = allIcons[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(with: .init(title: icon.title, value: ""), isChecked: icon.name == currentIcon.name)
        return cell
    }
}
