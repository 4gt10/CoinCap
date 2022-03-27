//
//  Collection+Extensions.swift
//  CoinCap
//
//  Created by Артур Чернов on 25.03.2022.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
