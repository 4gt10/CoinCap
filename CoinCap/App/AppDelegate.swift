//
//  AppDelegate.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    private var coordinator: AppCoordinator?
    private let assetsService: AssetsService = NetworkAssetsService()
    private let favoritesService: FavoritesService = UserDefaultsFavoritesService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureAppFlow()
        return true
    }
}

// MARK: - Flow
private extension AppDelegate {
    func configureAppFlow() {
        let tabBarController = UITabBarController()
        coordinator = AppCoordinator(tabBarController: tabBarController, assetsService: assetsService, favoritesService: favoritesService)
        coordinator?.start()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
