//
//  WatchlistCoordinator.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import UIKit

protocol WatchlistCoordinator: AssetsCoordinator {
    
}

final class WatchlistCoordinatorImpl {
    private(set) var childCoordinators = [Coordinator]()
    private var navigationController: UINavigationController
    private let assetsService: AssetsService
    private let favoritesService: FavoritesService
    
    init(navigationController: UINavigationController, assetsService: AssetsService, favoritesService: FavoritesService) {
        self.navigationController = navigationController
        self.assetsService = assetsService
        self.favoritesService = favoritesService
    }
    
    func start() {
        let viewController = WatchlistViewController.instantiate()
        viewController.coordinator = self
        viewController.tabBarItem = .init(title: R.string.localizable.watchlistTitle(), image: R.image.favorites(), tag: 1)
        viewController.dataController = WatchListDataController(assetsService: assetsService, favoritesService: favoritesService)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - Navigation
extension WatchlistCoordinatorImpl: WatchlistCoordinator {
    func openAssetDetails(_ asset: Asset) {
        let viewController = AssetDetailsViewController.instantiate()
        viewController.coordinator = self
        viewController.setDataController(.init(asset: asset, assetsService: assetsService, favoritesService: favoritesService))
        navigationController.pushViewController(viewController, animated: true)
    }
}
