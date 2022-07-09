//
//  SettingsData.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import Foundation

enum SettingsData {
    case icon(AppIconService.Icon)
}

extension SettingsData {
    var detailItem: DetailItem {
        switch self {
        case let .icon(icon):
            return .init(title: R.string.localizable.settingsIconTitle(), value: icon.title)
        }
    }
}

extension SettingsData: Identifiable {
    var id: Int {
        switch self {
        case let .icon(icon):
            return icon.hashValue
        }
    }
}
