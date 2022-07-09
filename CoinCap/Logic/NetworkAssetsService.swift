//
//  NetworkAssetsService.swift
//  CoinCap
//
//  Created by Артур Чернов on 26.03.2022.
//

import Foundation

final class NetworkAssetsService {
    private let session: URLSession
    private let tasksSyncQueue = DispatchQueue(label: "com.gmail.forgot10soul.CoinCap.NetworkAssetsService.tasksSyncQueue")
    private var _tasks = [URLSessionDataTask]()
    private var tasks: [URLSessionDataTask] {
        get {
            var tmpTasks = [URLSessionDataTask]()
            tasksSyncQueue.sync {
                tmpTasks = _tasks
            }
            return tmpTasks
        }
        set {
            tasksSyncQueue.sync(flags: .barrier) { [weak self] in
                self?._tasks = newValue
            }
        }
    }
    
    // MARK: - Lifecycle
    init() {
        self.session = URLSession(configuration: .default)
    }
}

extension NetworkAssetsService: AssetsService {
    func fetchAssets(query: String, ids: [String], limit: Int, offset: Int, completion: @escaping (Result<[Asset], AssetsServiceError>) -> Void) -> Void {
        request(API.assets(query: query, ids: ids, limit: limit, offset: offset).urlRequest, completion: completion)
    }
    
    func fetchAsset(withId id: String, completion: @escaping (Result<Asset, AssetsServiceError>) -> Void) -> Void {
        request(API.asset(id: id).urlRequest, completion: completion)
    }
    
    func fetchHistory(
        withId id: String,
        interval: AssetHistoryData.Interval,
        from: Date,
        till: Date,
        completion: @escaping (Result<[AssetHistoryData], AssetsServiceError>) -> Void
    ) -> Void {
        request(API.history(id: id, interval: interval, from: from, till: till).urlRequest, completion: completion)
    }
}

private extension NetworkAssetsService {
    func request<T: Decodable>(_ request: URLRequest, completion: @escaping (Result<T, AssetsServiceError>) -> Void) {
        let taskDescription = request.description
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            self?.log(response: response, data: data)

            if let taskIndex = self?.tasks.firstIndex(where: { $0.taskDescription == taskDescription }) {
                self?.tasks.remove(at: taskIndex)
            }
            if let error = error {
                completion(.failure(.underlyingError(error)))
                return
            }
            if
                let data = data,
                let response = try? JSONDecoder().decode(Response<T>.self, from: data) {
                completion(.success(response.data))
            } else {
                completion(.failure(.incorrectData))
            }
        }
        task.taskDescription = taskDescription
        task.resume()
        tasks.append(task)
    }
    
    func log(response: URLResponse?, data: Data?) {
        #if DEBUG
        guard
            let response = response,
            let data = data,
            let json = try? JSONSerialization.jsonObject(with: data) else {
            return
        }
        print("Response: \(response.description)\nData: \(json)")
        #endif
    }
}
