//
//  HomePresenterSpec.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Weather

class HomePresenterSpec: QuickSpec {

    override func spec() {
        describe("The HomePresenter") {
            context("when it's initialized with a mock interactor") {
                it("should be able to register cells") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    let collectionView = TestStubHelper.generateCollectionView()
                    presenter.registerCells(collectionView: collectionView)
                    expect(collectionView.dequeueReusableCell(withReuseIdentifier: SummaryCollectionViewCell.reuseId, for: IndexPath(item: 0, section: 0))).toNot(beNil())
                    expect(collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseId, for: IndexPath(item: 0, section: 1))).toNot(beNil())
                }

                it("should be able to register the delegates") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    let collectionView = TestStubHelper.generateCollectionView()
                    presenter.setupDelegates(collectionView: collectionView)
                    expect(collectionView.delegate).toNot(beNil())
                    expect(collectionView.dataSource).toNot(beNil())
                    expect(collectionView.delegate).to(beAnInstanceOf(HomePresenter.self))
                    expect(collectionView.dataSource).to(beAnInstanceOf(HomePresenter.self))
                }

                it("should be able to retrieve weather data from a mock interactor") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    presenter.loadWeatherData(location: "Cape Town") { error in
                        expect(error).to(beNil())
                        expect(presenter.currentWeatherData).toNot(beNil())
                        expect(presenter.dailyForecasts).toNot(beEmpty())
                    }
                }

                it("should set the correct current/min/max temperatures in the cells") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    let collectionView = TestStubHelper.generateCollectionView()
                    presenter.currentWeatherData = TestStubHelper.getStubbedResponseForType(codable: CurrentWeatherData.self, name: "city_weather_success_stub")

                    guard let testCurrentData = presenter.currentWeatherData else {
                            fail("Unable to get test data")
                            return
                    }

                    presenter.registerCells(collectionView: collectionView)
                    presenter.setupDelegates(collectionView: collectionView)

                    let tempMin = String(Int(testCurrentData.main.tempMin.rounded()))
                    let tempCurrent = String(Int(testCurrentData.main.temp.rounded()))
                    let tempMax = String(Int(testCurrentData.main.tempMax.rounded()))
                    let temps = [tempMin, tempCurrent, tempMax]

                    for (index, temp) in temps.enumerated() {
                        let cell = presenter.collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: 0)) as? SummaryCollectionViewCell
                        expect(cell?.tempLabel.text).to(contain(temp))
                    }
                }

                it("should get the correct day forecasts") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    let collectionView = TestStubHelper.generateCollectionView()
                    presenter.dailyForecasts = TestStubHelper.getStubbedResponseForType(codable: DayForecastData.self, name: "city_forecast_success_stub")?.days ?? []

                    if presenter.dailyForecasts.isEmpty {
                        fail("Unable to get test data")
                        return
                    }

                    presenter.registerCells(collectionView: collectionView)
                    presenter.setupDelegates(collectionView: collectionView)

                    for (index, forecast) in presenter.dailyForecasts.enumerated() {
                        let cell = presenter.collectionView(collectionView, cellForItemAt: IndexPath(item: index, section: 1)) as? ForecastCollectionViewCell
                        expect(cell?.dayLabel).toNot(beNil())
                        let temp = String(Int(forecast.main.temp.rounded()))
                        expect(cell?.tempLabel.text).to(contain(temp))
                        expect(cell?.weatherImageView.image).toNot(beNil())
                    }
                }

                it("should be able to set the correct details on the UILabels") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    presenter.currentWeatherData = TestStubHelper.getStubbedResponseForType(codable: CurrentWeatherData.self, name: "city_weather_success_stub")

                    guard let testCurrentData = presenter.currentWeatherData else {
                            fail("Unable to get test data")
                            return
                    }
                    let tempCurrent = String(Int(testCurrentData.main.temp.rounded()))
                    let currentConditions = testCurrentData.weather.first?.weatherDescription

                    let tempLabel = UILabel()
                    let conditionsLabel = UILabel()
                    presenter.setTempAndDescriptionLabels(tempLabel: tempLabel,
                                                          descriptionLabel: conditionsLabel)

                    expect(tempLabel.text).to(contain(tempCurrent))
                    expect(conditionsLabel.text).to(equal(currentConditions?.uppercased()))
                }

                it("should not set the UILabels if no data is available") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    let tempLabel = UILabel()
                    let conditionsLabel = UILabel()
                    presenter.setTempAndDescriptionLabels(tempLabel: tempLabel,
                                                          descriptionLabel: conditionsLabel)
                    expect(tempLabel.text).to(beNil())
                    expect(conditionsLabel.text).to(beNil())
                }

                it("should be able to get the WeatherContext for the current conditions") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    presenter.currentWeatherData = TestStubHelper.getStubbedResponseForType(codable: CurrentWeatherData.self, name: "city_weather_success_stub")

                    let context = presenter.getContextForCurrentConditions()
                    expect(context.rawValue).to(equal(WeatherContext.sunny.rawValue))
                }

                it("should fall back onto 'Sunny' when no conditions are set") {
                    let presenter = HomePresenter(interactor: MockHomeInteractor())
                    presenter.currentWeatherData = nil
                    let context = presenter.getContextForCurrentConditions()
                    expect(context.rawValue).to(equal(WeatherContext.sunny.rawValue))
                }
            }
        }
    }
}
