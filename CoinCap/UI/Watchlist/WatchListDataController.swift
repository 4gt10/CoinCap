//
//  WatchListDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation
import UIKit

final class WatchListDataController: AssetsDataController {
    private let favoritesService: FavoritesService = UserDefaultsFavoritesService()
    private var onDelete: (() -> Void)?
    
    var isEmpty: Bool { favoritesService.all.isEmpty }
    
    init(onLoaded: (() -> Void)?, onError: ((AssetsDataControllerError) -> Void)?, onDelete: (() -> Void)?) {
        super.init(onLoaded: onLoaded, onError: onError)
        self.onDelete = onDelete
    }
    
    func reload() {
        let favorites = favoritesService.all
        guard !favorites.isEmpty else {
            return
        }
        reload(ids: favorites)
    }
}

extension WatchListDataController {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let asset = item(at: indexPath) else {
            return
        }
        favoritesService.remove(id: asset.id)
        onDelete?()
    }
}
