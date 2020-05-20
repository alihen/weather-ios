//
//  TestStubHelper.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/17.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit
@testable import Weather

class TestStubHelper {

    class func dataFromStub(named name: String) -> Data {
        guard
            let fileURL = Bundle.init(for: TestStubHelper.self).url(forResource:name, withExtension: "json"),
            let data = try? Data(contentsOf: fileURL) else {
                return Data()
        }
        return data
    }

    class func getStubbedResponseForType<C: Decodable>(codable: C.Type, name: String) -> C? {
        let data = dataFromStub(named: name)
        var encodableResponse: C?
        do {
            encodableResponse = try JSONDecoder().decode(codable.self, from: data)
        } catch {
            debugPrint(error)
        }
        return encodableResponse
    }

    class func generateCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }

    class func setupMockWeatherService(stub: String) -> WeatherAPIService {
        let session = MockURLSession()
        let service = WeatherAPIService(session: session)
        session.data = TestStubHelper.dataFromStub(named: stub)
        return service
    }
}
