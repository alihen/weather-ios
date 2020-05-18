//
//  HomePresenter.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class HomePresenter: NSObject {

    let interactor: HomeInteractorProtocol
    let location = "Cape Town"
    var currentWeatherData: CurrentWeatherData?
    var dailyForecasts: [Forecast] = []

    init(interactor: HomeInteractorProtocol = HomeInteractor()) {
        self.interactor = interactor
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
        interactor.getWeatherData(location: self.location) { (weatherData, error) in
            if weatherData != nil {
                self.currentWeatherData = weatherData
            }

            self.interactor.getForecastData(location: self.location) { (forecasts, error) in
                if let forecasts = forecasts {
                    self.dailyForecasts = forecasts
                }
                completion(error)
            }
        }
    }

    func setTempAndDescriptionLabels(tempLabel: UILabel, descriptionLabel: UILabel) {
        guard
            let weatherData = currentWeatherData,
            let currentConditions = weatherData.weather.first?.weatherDescription else {
            return
        }

        let currentTemp = Int(weatherData.main.temp)

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
}

extension HomePresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return dailyForecasts.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryCollectionViewCell.reuseId, for: indexPath) as! SummaryCollectionViewCell
            cell.styleCell(item: indexPath.row)
            guard let weatherData = currentWeatherData else {
                return cell
            }
            switch indexPath.row {
            case 0:
                cell.tempLabel.text = "\(Int(weatherData.main.tempMin))°"
            case 1:
                cell.tempLabel.text = "\(Int(weatherData.main.temp))°"
            case 2:
                cell.tempLabel.text = "\(Int(weatherData.main.tempMax))°"
            default:
                break
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseId, for: indexPath) as! ForecastCollectionViewCell
            let item = dailyForecasts[indexPath.row]
            cell.dayLabel.text = getDayOfWeek(timestamp: item.dt)
            cell.tempLabel.text = "\(Int(item.main.temp))°"

            if let conditionId = item.weather.first?.id {
                let cellImageName = getContextForId(id: conditionId).forecastIconName
                cell.weatherImageView.image = UIImage(named: cellImageName)
            }
            return cell
        }
    }

    private func getDayOfWeek(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let weekDay = dateFormatter.string(from:date)
        return weekDay
    }
}

extension HomePresenter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: (UIScreen.main.bounds.width/3)-10, height: 48)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 40)
        }

    }
}
