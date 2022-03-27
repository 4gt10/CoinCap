//
//  SettingsDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation
import UIKit

final class SettingsDataController: NSObject {
    private let appIconService = AppIconService()
    private var currentIcon: AppIconService.Icon { appIconService.current }
}

extension SettingsDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailCell, for: indexPath) else {
            return .init()
        }
        cell.configure(with: .init(title: R.string.localizable.settingsIconTitle(), value: currentIcon.title))
        return cell
    }
}
