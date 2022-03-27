//
//  Asset.swift
//  CoinCap
//
//  Created by Артур Чернов on 25.03.2022.
//

import Foundation

struct Asset: Decodable {
    let id: String
    let symbol: String?
    let name: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let marketCapUsd: String?
    let supply: String?
    let volumeUsd24Hr: String?
}

extension Asset {
    var isGrowing: Bool { NSDecimalNumber(string: changePercent24Hr).doubleValue > 0 }
    var readablePrice: String? { priceUsd?.currency }
    var readablePriceChange: String? { changePercent24Hr?.percent }
    var readableMarketCap: String? { marketCapUsd?.currency }
    var readableSupply: String? { supply?.currency }
    var readableVolume: String? { volumeUsd24Hr?.currency }
    var logoURL: URL? {
        guard
            let symbol = symbol?.lowercased(),
            let url = URL(string: "https://cryptologos.cc/logos/\(id)-\(symbol)-logo.png") else {
            return nil
        }
        return url
    }
}
