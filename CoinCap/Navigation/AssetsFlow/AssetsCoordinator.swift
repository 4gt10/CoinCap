//
//  AssetsCoordinator.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import UIKit

protocol AssetsCoordinator: Coordinator {
    func openAssetDetails(_ asset: Asset)
}

final class AssetsCoordinatorImpl {
    private(set) var childCoordinators = [Coordinator]()
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = AssetsViewController.instantiate()
        viewController.coordinator = self
        viewController.tabBarItem = .init(title: R.string.localizable.assetsTitle(), image: R.image.assets(), tag: 0)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - Navigation
extension AssetsCoordinatorImpl: AssetsCoordinator {
    func openAssetDetails(_ asset: Asset) {
        let viewController = AssetDetailsViewController.instantiate()
        viewController.coordinator = self
        viewController.setDataController(.init(asset: asset))
        navigationController.pushViewController(viewController, animated: true)
    }
}
