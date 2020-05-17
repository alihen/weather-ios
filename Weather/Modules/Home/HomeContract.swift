//
//  HomeContract.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

protocol HomePresenterProtocol {
    func registerCells(collectionView: UICollectionView)
    func setupDelegates(collectionView: UICollectionView)
    func loadWeatherData(location: String, completion: @escaping (Error?) -> Void)
    func setTempAndDescriptionLabels(tempLabel: UILabel, descriptionLabel: UILabel)
}
