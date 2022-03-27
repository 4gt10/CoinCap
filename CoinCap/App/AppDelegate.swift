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
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return false }
        window.rootViewController = R.storyboard.main.instantiateInitialViewController()
        window.makeKeyAndVisible()
        return true
    }
}

