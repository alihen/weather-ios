//
//  HomeInteractor.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class HomeInteractor: NSObject, HomeInteractorProtocol {

    let weatherAPIService: WeatherAPIService

    init(service: WeatherAPIService = WeatherAPIService()) {
        self.weatherAPIService = service
    }

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

    func getForecastData(location: String, completion: @escaping ([Forecast]?, Error?) -> Void) {
        weatherAPIService.getDailyWeatherForecast(forLocation: location) { result in
            switch result {
            case .success(let weather):
                let dailyWeather = weather.days.filter({ $0.dtTxt.hasSuffix("15:00:00")})
                completion(dailyWeather, nil)
                return
            case .failure(let error):
                completion(nil, error)
                return
            }
        }
    }
    
}
