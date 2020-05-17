//
//  WeatherAPIServiceTests.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/17.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import XCTest
@testable import Weather

class WeatherAPIServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    private func setupMockWeatherService(stub: String) -> WeatherAPIService {
        let session = MockURLSession()
        let service = WeatherAPIService(session: session)
        session.data = TestStubHelper.dataFromStub(named: stub)
        return service
    }

    func testWeatherServiceCurrentSuccess() throws {
        let weatherService = setupMockWeatherService(stub: "city_weather_success_stub")
        weatherService.getCurrentWeatherData(forLocation: "Cape Town") { result in
            switch result {
            case .success(let weather):
                XCTAssertNotNil(weather)
            case .failure(let error):
                XCTAssertNil(error)
            }
        }
    }

    func testWeatherServiceCurrentMalformed() throws {
        let weatherService = setupMockWeatherService(stub: "city_weather_malformed_stub")
        weatherService.getCurrentWeatherData(forLocation: "Cape Town") { result in
            switch result {
            case .success(let weather):
                XCTAssertNil(weather)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
        }
    }

}
