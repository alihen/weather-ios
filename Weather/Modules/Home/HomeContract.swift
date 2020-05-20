//
//  HomeContract.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

protocol HomePresenterProtocol {
    var currentWeatherData: CurrentWeatherData? { get set }
    var dailyForecasts: [Forecast] { get set }
    var viewController: HomeViewController? { get set }

    func registerCells(collectionView: UICollectionView)
    func setupDelegates(collectionView: UICollectionView)
    func loadWeatherData(location: String, completion: @escaping (Error?) -> Void)
    func setTempAndDescriptionLabels(tempLabel: UILabel, descriptionLabel: UILabel)
    func getContextForCurrentConditions() -> WeatherContext
    func getContextForId(id: Int) -> WeatherContext
    func startUpdatingLocation()
    func getSavedLocation() -> String?
}

protocol HomeInteractorProtocol {
    func getWeatherData(location: String, completion: @escaping (CurrentWeatherData?, Error?) -> Void)
    func getForecastData(location: String, completion: @escaping ([Forecast]?, Error?) -> Void)
}
