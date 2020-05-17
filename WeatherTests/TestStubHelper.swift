//
//  TestStubHelper.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/17.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class TestStubHelper {

    class func dataFromStub(named name: String) -> Data {
        guard
            let fileURL = Bundle.init(for: TestStubHelper.self).url(forResource:name, withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else {
                return Data()
        }
        return data
    }
}
