//
//  AssetHistoryData.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

struct AssetHistoryData: Decodable {
    enum Interval: String {
        case m1, m5, m15, m30, h1, h2, h6, h12, d1
    }
    let priceUsd: String?
    let time: TimeInterval
}

extension AssetHistoryData {
    var price: Double { priceUsd?.double ?? 0 }
}
