//
//  AssetsService.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import Foundation

enum AssetsServiceError: Error {
    case incorrectData
    case underlyingError(Error)
    
    var localizedDescription: String {
        switch self {
        case .incorrectData:
            return R.string.localizable.errorIncorrectData()
        case .underlyingError(let error):
            return error.localizedDescription
        }
    }
}

protocol AssetsService {
    func fetchAssets(query: String, ids: [String], limit: Int, offset: Int, completion: @escaping (Result<[Asset], AssetsServiceError>) -> Void) -> Void
    func fetchAsset(withId: String, completion: @escaping (Result<Asset, AssetsServiceError>) -> Void) -> Void
    func fetchHistory(
        withId id: String,
        interval: AssetHistoryData.Interval,
        from: Date,
        till: Date,
        completion: @escaping (Result<[AssetHistoryData], AssetsServiceError>) -> Void
    )
}
