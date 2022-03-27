//
//  String+Extensions.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

extension String {
    var currency: String? {
        NumberFormatter.default.numberStyle = .currency
        return NumberFormatter.default.string(from: NSDecimalNumber(string: self))
    }
    
    var percent: String? {
        let number = NSDecimalNumber(string: self)
        NumberFormatter.default.numberStyle = .percent
        NumberFormatter.default.multiplier = 1
        if let string = NumberFormatter.default.string(from: number), number.doubleValue >= 0 {
            return "+\(string)"
        }
        return NumberFormatter.default.string(from: number)
    }
    
    var double: Double {
        NSDecimalNumber(string: self).doubleValue
    }
}
