//
//  AssetLogoURLBuilder.swift
//  CoinCap
//
//  Created by 4gt10 on 09.07.2022.
//

import Foundation

enum AssetLogoURLBuilder {
    static func build(forId id: String, symbol: String?) -> URL? {
        guard let symbol = symbol?.lowercased() else { return nil }
        return URL(string: "https://cryptologos.cc/logos/\(id)-\(symbol.lowercased())-logo.png")
    }
}
