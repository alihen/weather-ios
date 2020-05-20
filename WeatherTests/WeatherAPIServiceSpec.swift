//
//  WeatherAPIServiceSpec.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/17.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Weather

class WeatherAPIServiceSpec: QuickSpec {

    override func spec() {
        describe("WeatherAPIService") {
            context("when it fetches the current weather") {
                it("should be able to retrieve the correct weather data") {
                    let weatherService = TestStubHelper.setupMockWeatherService(stub: "city_weather_success_stub")
                    weatherService.getCurrentWeatherData(forLocation: "Cape Town") { result in
                        switch result {
                        case .success(let weather):
                            expect(weather).toNot(beNil())
                            expect(weather).to(beAnInstanceOf(CurrentWeatherData.self))
                        case .failure(let error):
                            expect(error).to(beNil())
                        }
                    }
                }

                it("should return the appropriate error when fetching malformed data") {
                    let weatherService = TestStubHelper.setupMockWeatherService(stub: "city_weather_malformed_stub")
                    weatherService.getCurrentWeatherData(forLocation: "Cape Town") { result in
                        switch result {
                        case .success(let weather):
                            expect(weather).to(beNil())
                        case .failure(let error):
                            expect(error).toNot(beNil())
                            expect(error.localizedDescription).to(equal("The data couldn’t be read because it is missing."))
                        }
                    }
                }

                it("should return an API Response Erro when encountering an API error") {
                    let weatherService = TestStubHelper.setupMockWeatherService(stub: "city_weather_api_error_stub")
                    weatherService.getCurrentWeatherData(forLocation: "Cape Town") { result in
                        switch result {
                        case .success(let weather):
                            expect(weather).to(beNil())
                        case .failure(let error):
                            expect(error).toNot(beNil())
                            expect(error.localizedDescription).to(equal("API Key is invalid - Please use a valid API Key"))
                        }
                    }
                }
            }

            context("when it fetches the 5 day forecast") {
                it("should be able to retrieve the correct weather data") {
                    let weatherService = TestStubHelper.setupMockWeatherService(stub: "city_forecast_success_stub")
                    weatherService.getDailyWeatherForecast(forLocation: "Cape Town") { result in
                        switch result {
                        case .success(let weather):
                            expect(weather).toNot(beNil())
                            expect(weather).to(beAnInstanceOf(DayForecastData.self))
                        case .failure(let error):
                            expect(error).to(beNil())
                        }
                    }
                }
            }
        }
    }
}
