//
//  APIService.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/14.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

struct APIService {

    private let session: URLSession
    typealias APIHandler = (Result<Data, APIError>) -> Void

    init(session: URLSession = URLSession.shared) {
        self.session = session
    }

    func get(endpoint: APIDefinition, completion: @escaping APIHandler) {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = "\(endpoint.rootPath)\(endpoint.path)"
        components.queryItems = endpoint.parameters

        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }

        let task = session.dataTask(with: url) { (data, _, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
            } else {
                completion(.success(data ?? Data()))
            }
        }

        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case networkError(Error)
}
