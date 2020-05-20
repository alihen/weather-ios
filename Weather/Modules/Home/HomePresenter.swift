//
//  HomePresenter.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit
import CoreLocation

class HomePresenter: NSObject {

    let interactor: HomeInteractorProtocol
    var currentWeatherData: CurrentWeatherData?
    var dailyForecasts: [Forecast] = []
    let locationManager = LocationService()
    weak var viewController: HomeViewController?

    init(interactor: HomeInteractorProtocol = HomeInteractor()) {
        self.interactor = interactor
        super.init()
        self.locationManager.delegate = self
    }
}

extension HomePresenter: HomePresenterProtocol {

    func registerCells(collectionView: UICollectionView) {
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseId)
        collectionView.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: SummaryCollectionViewCell.reuseId)
    }

    func setupDelegates(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func loadWeatherData(location: String, completion: @escaping (Error?) -> Void) {
        saveLocation(location: location)
        interactor.getWeatherData(location: location) { (weatherData, weatherError) in
            if weatherData != nil {
                self.currentWeatherData = weatherData
            }

            self.interactor.getForecastData(location: location) { (forecasts, forecastError) in
                if let forecasts = forecasts {
                    self.dailyForecasts = forecasts
                }

                if weatherError != nil {
                    completion(weatherError)
                } else {
                    completion(forecastError)
                }

            }
        }
    }

    func setTempAndDescriptionLabels(tempLabel: UILabel, descriptionLabel: UILabel) {
        guard
            let weatherData = currentWeatherData,
            let currentConditions = weatherData.weather.first?.weatherDescription else {
            return
        }

        let currentTemp = Int(weatherData.main.temp.rounded())

        tempLabel.text = "\(currentTemp)°"
        descriptionLabel.text = currentConditions.uppercased()
    }

    func getContextForCurrentConditions() -> WeatherContext {
        guard let weatherCode = currentWeatherData?.weather.first?.id else {
            return .sunny
        }
        return getContextForId(id: weatherCode)
    }

    func getContextForId(id: Int) -> WeatherContext {
        switch id {
        case 200..<600:
            return .rainy
        case 600..<700:
            return .cloudy
        case 800:
            return .sunny
        case 801..<900:
            return .cloudy
        default:
            return .sunny
        }
    }

    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    private func saveLocation(location: String) {
        UserDefaults.standard.set(location, forKey: "saved-location")
    }

    func getSavedLocation() -> String? {
        return UserDefaults.standard.string(forKey: "saved-location")
    }
}

extension HomePresenter: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {

        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default:
            
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.isEmpty {
            return
        }
        
        locationManager.stopUpdatingLocation()
        locationManager.getPlaceForCurrentLocation { placemark in
            if
                let locality = placemark?.locality,
                let country = placemark?.country {
                self.viewController?.location = "\(locality), \(country)"
                self.viewController?.loadWeatherInfo()
            }
        }
    }
}
