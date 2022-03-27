//
//  API.swift
//  CoinCap
//
//  Created by Артур Чернов on 22.03.2022.
//

import Foundation

enum API {
    enum Method: String {
        case get = "GET"
    }
    
    case assets(query: String, ids: [String], limit: Int, offset: Int)
    case asset(id: String)
    case history(id: String, interval: AssetHistoryData.Interval, from: Date, till: Date)
    
    var baseURL: URL {
        .init(string: "https://api.coincap.io/v2/")!
    }
    
    var path: String {
        switch self {
        case .assets: return "assets"
        case let .asset(id): return "assets/\(id)"
        case let .history(id, _, _, _): return "assets/\(id)/history"
        }
    }
    
    var method: Method {
        switch self {
        case .assets, .asset, .history:
            return .get
        }
    }
    
    var headers: [String: String] {
        switch self {
        case .assets, .asset, .history:
            return ["Accept": "application/json"]
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case let .assets(query, ids, limit, offset):
            return [
                "search": query,
                "ids": ids.joined(separator: ","),
                "limit": limit,
                "offset": offset
            ]
        case .asset:
            return [:]
        case let .history(_, interval, from, till):
            return [
                "interval": interval.rawValue,
                "start": from.timeIntervalSince1970 * AppConstant.Time.millisecondsInSecond,
                "end": till.timeIntervalSince1970 * AppConstant.Time.millisecondsInSecond
            ]
        }
    }
    
    var urlRequest: URLRequest {
        var urlComponents = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)!
        switch method {
        case .get:
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0, value: $1 as? String ?? "\($1)") }
        }
        var urlRequest = URLRequest(url: urlComponents.url!)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}
