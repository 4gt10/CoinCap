//
//  AppCoordinator.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import UIKit

final class AppCoordinator: Coordinator {
    private(set) var childCoordinators = [Coordinator]()
    private var tabBarController: UITabBarController
    
    init(tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }
    
    func start() {
        let assetsNavigationController = UINavigationController()
        let assetsCoordinator = AssetsCoordinatorImpl(navigationController: assetsNavigationController)
        childCoordinators.append(assetsCoordinator)
        assetsCoordinator.start()
        
        let watchlistNavigationController = UINavigationController()
        let watchlistCoordinator = WatchlistCoordinatorImpl(navigationController: watchlistNavigationController)
        childCoordinators.append(watchlistCoordinator)
        watchlistCoordinator.start()
        
        let settingsNavigationController = UINavigationController()
        let settingsCoordinator = SettingsCoordinatorImpl(navigationController: settingsNavigationController)
        childCoordinators.append(settingsCoordinator)
        settingsCoordinator.start()
        
        tabBarController.setViewControllers(
            [assetsNavigationController, watchlistNavigationController, settingsNavigationController],
            animated: false
        )
    }
}
