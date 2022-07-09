//
//  AssetDetailsDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import UIKit
import Foundation

enum AssetDetailsDataControllerError: Error {
    case incorrectData
    case underlyingError(Error)
    
    init(_ error: AssetsServiceError) {
        switch error {
        case .incorrectData:
            self = .incorrectData
        case .underlyingError(let error):
            self = .underlyingError(error)
        }
    }
    
    var localizedDescription: String {
        switch self {
        case .incorrectData:
            return R.string.localizable.errorIncorrectData()
        case .underlyingError(let error):
            return error.localizedDescription
        }
    }
}

final class AssetDetailsDataController: NSObject {
    var symbol: String? { asset.symbol }
    var name: String? { asset.name }
    var price: String? { asset.readablePrice }
    var priceChange: String? { asset.readablePriceChange }
    var isGrowing: Bool { asset.isGrowing }
    var isFavorite: Bool { favoritesService.isFavorite(id: asset.id) }
    var onGraphDataLoaded: (([AssetHistoryData]) -> Void)?
    var onError: ((AssetDetailsDataControllerError) -> Void)?
    
    private var asset: Asset
    private var items: [DetailItem]
    private let assetsService: AssetsService = NetworkAssetsService()
    private let favoritesService: FavoritesService = UserDefaultsFavoritesService()
    
    init(asset: Asset) {
        self.asset = asset
        self.items = asset.items
        
        super.init()
    }
    
    func reloadGraphData() {
        let now = Date().timeIntervalSince1970
        assetsService.fetchHistory(
            withId: asset.id,
            interval: .m5,
            from: Date(timeIntervalSince1970: now.advanced(by: -AppConstant.Time.secondsInDay)),
            till: Date(timeIntervalSince1970: now)
        ) { [weak self] result in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                switch result {
                case let .success(data):
                    self.onGraphDataLoaded?(data)
                case let .failure(error):
                    self.onError?(.init(error))
                }
            }
        }
    }
    
    func addFavorite() {
        favoritesService.add(id: asset.id)
    }
    
    func removeFavorite() {
        favoritesService.remove(id: asset.id)
    }
}

extension AssetDetailsDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.detailCell, for: indexPath),
            let item = items[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(with: item)
        return cell
    }
}

extension Asset {
    var items: [DetailItem] {
        var items = [DetailItem]()
        if let readableMarketCap = readableMarketCap {
            items.append(.init(title: R.string.localizable.assetDetailsItemMarketCapTitle(), value: readableMarketCap))
        }
        if let readableSupply = readableSupply {
            items.append(.init(title: R.string.localizable.assetDetailsItemSupplyTitle(), value: readableSupply))
        }
        if let readableVolume = readableVolume {
            items.append(.init(title: R.string.localizable.assetDetailsItemVolumeTitle(), value: readableVolume))
        }
        return items
    }
}
 
