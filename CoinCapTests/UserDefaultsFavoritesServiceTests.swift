//
//  UserDefaultsFavoritesServiceTests.swift
//  CoinCapTests
//
//  Created by Артур Чернов on 27.03.2022.
//

import XCTest
@testable import CoinCap

final class UserDefaultsFavoritesServiceTests: XCTestCase {
    private let service = UserDefaultsFavoritesService()
    
    func testFavoritesManagement() {
        service.removeAll()
        
        let id = "bitcoin"
        service.add(id: id)
        XCTAssertTrue(service.isFavorite(id: id))
        service.remove(id: id)
        XCTAssertFalse(service.isFavorite(id: id))
    }
    
    func testFavoritesFetching() {
        service.removeAll()
        
        let ids = ["bitcoin", "etherium", "doge", "usdt"]
        ids.forEach {
            service.add(id: $0)
        }
        XCTAssertEqual(service.all.count, ids.count)
    }
}
