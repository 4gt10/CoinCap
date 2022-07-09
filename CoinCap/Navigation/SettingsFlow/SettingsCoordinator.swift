//
//  SettingsCoordinator.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import UIKit

protocol SettingsCoordinator: Coordinator {
    func openSettings(_ settingsData: SettingsData)
}

final class SettingsCoordinatorImpl {
    private(set) var childCoordinators = [Coordinator]()
    private var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewController = SettingsViewController.instantiate()
        viewController.coordinator = self
        viewController.tabBarItem = .init(title: R.string.localizable.settingsTitle(), image: R.image.settings(), tag: 2)
        navigationController.setViewControllers([viewController], animated: false)
    }
}

// MARK: - Navigation
extension SettingsCoordinatorImpl: SettingsCoordinator {
    func openSettings(_ settingsData: SettingsData) {
        switch settingsData {
        case .icon:
            openIconSettings()
        }
    }
    
    private func openIconSettings() {
        let viewController = SettingsIconViewController.instantiate()
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: true)
    }
}
