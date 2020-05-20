//
//  MockHomeInteractor.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
@testable import Weather

class MockHomeInteractor: HomeInteractorProtocol {
    func getWeatherData(location: String, completion: @escaping (CurrentWeatherData?, Error?) -> Void) {
        let response = TestStubHelper.getStubbedResponseForType(codable: CurrentWeatherData.self, name: "city_weather_success_stub")
        completion(response, nil)
    }

    func getForecastData(location: String, completion: @escaping ([Forecast]?, Error?) -> Void) {
        let response = TestStubHelper.getStubbedResponseForType(codable: DayForecastData.self, name: "city_forecast_success_stub")
        let forecast = response?.days ?? []
        completion(forecast, nil)
    }

    
}
