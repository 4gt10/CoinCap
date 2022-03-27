//
//  UserDefaultsFavoritesService.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

final class UserDefaultsFavoritesService {
    private enum Key {
        static let favorites = "favorites"
    }
    private let defaults = UserDefaults.standard
}

extension UserDefaultsFavoritesService: FavoritesService {
    var all: [String] {
        get { defaults.value(forKey: Key.favorites) as? [String] ?? [] }
        set {
            defaults.set(newValue, forKey: Key.favorites)
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil, userInfo: nil)
        }
    }
    
    func isFavorite(id: String) -> Bool {
        all.contains(id)
    }
    
    func add(id: String) {
        var favorites = all
        favorites.append(id)
        all = favorites
    }
    
    func remove(id: String) {
        var favorites = all
        if let indexToRemove = favorites.firstIndex(of: id) {
            favorites.remove(at: indexToRemove)
        }
        all = favorites
    }
    
    func removeAll() {
        defaults.removeObject(forKey: Key.favorites)
    }
}

