//
//  AppIconService.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation
import UIKit

final class AppIconService {
    enum Icon: CaseIterable {
        case white, black, yellow
        
        var name: String? {
            switch self {
            case .white: return nil
            case .black: return "BlackAppIcon"
            case .yellow: return "YellowAppIcon"
            }
        }
        
        var title: String {
            switch self {
            case .white: return R.string.localizable.settingsIconWhiteTitle()
            case .black: return R.string.localizable.settingsIconBlackTitle()
            case .yellow: return R.string.localizable.settingsIconYellowTitle()
            }
        }
    }
    
    static let shared = AppIconService()
    private init() {}
    
    var all: [Icon] { Icon.allCases }
    var current: Icon {
        Icon.allCases.first { $0.name == UIApplication.shared.alternateIconName } ?? .white
    }

    func set(_ appIcon: Icon) {
        guard current != appIcon, UIApplication.shared.supportsAlternateIcons else {
            return
        }
        UIApplication.shared.setAlternateIconName(appIcon.name) { _ in }
        NotificationCenter.default.post(name: .iconUpdated, object: nil)
    }
}
