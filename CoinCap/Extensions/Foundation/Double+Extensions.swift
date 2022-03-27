//
//  Double+Extensions.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

extension Double {
    var currency: String? {
        NumberFormatter.default.numberStyle = .currency
        return NumberFormatter.default.string(from: NSNumber(value: self))
    }
}
