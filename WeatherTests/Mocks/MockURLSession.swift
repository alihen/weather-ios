//
//  MockURLSession.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/14.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class MockURLSession: URLSession {

    override init() {}

    var data: Data?
    var error: Error?

    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let error = self.error

        return MockURLSessionDataTask {
            completionHandler(data, nil, error)
        }
    }
}
