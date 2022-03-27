//
//  Response.swift
//  CoinCap
//
//  Created by Артур Чернов on 25.03.2022.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    let data: T
}
