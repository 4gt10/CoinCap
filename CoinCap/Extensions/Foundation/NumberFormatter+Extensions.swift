//
//  NumberFormatter+Extensions.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

extension NumberFormatter {
    static let `default`: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}
