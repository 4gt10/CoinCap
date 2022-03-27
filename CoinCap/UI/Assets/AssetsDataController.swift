//
//  AssetsDataController.swift
//  CoinCap
//
//  Created by Артур Чернов on 25.03.2022.
//

import Foundation
import UIKit

private enum Constant {
    static let limit = 20
}

enum AssetsDataControllerError: Error {
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

class AssetsDataController: NSObject {
    private let assetsService: AssetsService = NetworkAssetsService()
    
    private var query = ""
    private var ids: [String] = []

    private var isLoading = false
    private var isEverythingLoaded = false
    
    private(set) var assets = [Asset]()
    private(set) var onLoaded: (() -> Void)?
    private(set) var onError: ((AssetsDataControllerError) -> Void)?
    
    init(onLoaded: (() -> Void)? = nil, onError: ((AssetsDataControllerError) -> Void)? = nil) {
        super.init()
        
        self.onLoaded = onLoaded
        self.onError = onError
    }
    
    func reload(withQuery query: String = "", ids: [String] = []) {
        self.query = query
        self.ids = ids
        isLoading = true
        isEverythingLoaded = false
        assetsService.fetchAssets(query: query, ids: ids, limit: Constant.limit, offset: 0) { [weak self] result in
            guard let self = self else {
                return
            }
            self.isLoading = false
            switch result {
            case let .success(assets):
                self.assets = assets
                DispatchQueue.main.async { self.onLoaded?() }
            case let .failure(error):
                DispatchQueue.main.async { self.onError?(.init(error)) }
            }
        }
    }
    
    func loadMoreIfNeeded(for indexPath: IndexPath) {
        guard indexPath.row >= assets.count - 1 && !isLoading && !isEverythingLoaded else {
            return
        }
        isLoading = true
        assetsService.fetchAssets(query: query, ids: ids, limit: Constant.limit, offset: assets.count) { [weak self] result in
            guard let self = self else {
                return
            }
            self.isLoading = false
            switch result {
            case let .success(assets):
                self.assets += assets
                self.isEverythingLoaded = assets.isEmpty
                DispatchQueue.main.async { self.onLoaded?() }
            case let .failure(error):
                DispatchQueue.main.async { self.onError?(.init(error)) }
            }
        }
    }
    
    func item(at indexPath: IndexPath) -> Asset? {
        assets[safe: indexPath.row]
    }
}

extension AssetsDataController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.assetCell, for: indexPath),
            let asset = assets[safe: indexPath.row] else {
            return .init()
        }
        cell.configure(with: asset)
        return cell
    }
}
