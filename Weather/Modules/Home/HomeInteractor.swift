//
//  HomeInteractor.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class HomeInteractor {

    let weatherAPIService = WeatherAPIService()

    func getWeatherData(location: String, completion: @escaping (CurrentWeatherData?, Error?) -> Void) {
        weatherAPIService.getCurrentWeatherData(forLocation: location) { result in
            switch result {
            case .success(let weather):
                completion(weather, nil)
                return
            case .failure(let error):
                completion(nil, error)
                return
            }
        }
    }
    
}
