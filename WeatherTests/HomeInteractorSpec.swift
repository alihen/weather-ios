//
//  HomeInteractorSpec.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Weather

class HomeInteractorSpec: QuickSpec {

    override func spec() {
        describe("The HomeInteractor") {
            context("when it's initialized with a mock service") {
                it("should be able to return the current weather data") {
                    let service = TestStubHelper.setupMockWeatherService(stub: "city_weather_success_stub")
                    let interactor = HomeInteractor(service: service)

                    interactor.getWeatherData(location: "Cape Town") { (weatherData, error) in
                        expect(weatherData).toNot(beNil())
                        expect(error).to(beNil())
                    }
                }

                it("should return an error when an API error is encounter") {
                    let service = TestStubHelper.setupMockWeatherService(stub: "city_weather_api_error_stub")
                    let interactor = HomeInteractor(service: service)

                    interactor.getWeatherData(location: "Cape Town") { (weatherData, error) in
                        expect(weatherData).to(beNil())
                        expect(error).toNot(beNil())
                        guard let error = error as? APIResponseError else {
                            fail("Unable to cast error")
                            return
                        }

                        expect(error.localizedDescription).to(equal("API Key is invalid - Please use a valid API Key"))
                    }
                }

                it("should be able to return the forecast weather data") {
                    let service = TestStubHelper.setupMockWeatherService(stub: "city_forecast_success_stub")
                    let interactor = HomeInteractor(service: service)

                    interactor.getForecastData(location: "Cape Town") { (forecasts, error) in
                        expect(forecasts).toNot(beNil())
                        expect(forecasts).toNot(beEmpty())
                        expect(forecasts?.count).to(equal(5))
                        expect(error).to(beNil())
                    }
                }
            }
        }
    }
}
