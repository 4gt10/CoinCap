//
//  FavoritesService.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

protocol FavoritesService {
    var all: [String] { get set }
    
    func isFavorite(id: String) -> Bool
    func add(id: String)
    func remove(id: String)
    func removeAll()
}
