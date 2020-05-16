//
//  MockURLSessionDataTask.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/14.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTask {

    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}
