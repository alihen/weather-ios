//
//  WeatherAPIService.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class WeatherAPIService: APIService {

    func getCurrentWeatherData(forLocation location: String, completion: @escaping NetworkServiceResponse<CurrentWeatherData>) {
        get(endpoint: WeatherAPIRoute.currentWeather(location)) { result in
            completion(ResponseHelper.handle(CurrentWeatherData.self, result: result))
        }
    }

    func getDailyWeatherForecast(forLocation location: String, completion: @escaping NetworkServiceResponse<DayForecastData>) {
        get(endpoint: WeatherAPIRoute.forecastDaily(location)) { result in
            completion(ResponseHelper.handle(DayForecastData.self, result: result))
        }
    }
}
