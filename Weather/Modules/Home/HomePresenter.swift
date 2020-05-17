//
//  HomePresenter.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class HomePresenter: NSObject {

    let interactor = HomeInteractor()
    let location = "Cape Town"
    var currentWeatherData: CurrentWeatherData?
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
            completion(error)
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
}

extension HomePresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 5
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
            return cell
        }
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
