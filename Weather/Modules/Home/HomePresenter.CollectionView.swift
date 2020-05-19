//
//  HomePresenter.CollectionView.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

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
                cell.tempLabel.text = "\(Int(weatherData.main.tempMin.rounded()))°"
            case 1:
                cell.tempLabel.text = "\(Int(weatherData.main.temp.rounded()))°"
            case 2:
                cell.tempLabel.text = "\(Int(weatherData.main.tempMax.rounded()))°"
            default:
                break
            }
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseId, for: indexPath) as! ForecastCollectionViewCell
            let item = dailyForecasts[indexPath.row]
            cell.dayLabel.text = getDayOfWeek(timestamp: item.dt)
            cell.tempLabel.text = "\(Int(item.main.temp.rounded()))°"

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
