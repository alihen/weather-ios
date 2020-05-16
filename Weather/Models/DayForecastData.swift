//
//  DayForecastData.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

struct DayForecastData: Decodable {
    let days: [Forecast]
    let city: ForecastCity

    enum CodingKeys: String, CodingKey {
        case days = "list"
        case city
    }
}


struct ForecastCity: Decodable {
    let id: Int
    let name: String
    let coord: WeatherCoordinates
    let country: String
    let population: Int?
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}


struct Forecast: Decodable {
    let dt: Int
    let main: MainForecast
    let weather: [ForecastWeatherInfo]
    let clouds: CloudInfo
    let wind: WindInfo
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind
        case dtTxt = "dt_txt"
    }

    struct MainForecast: Decodable {
        let temp, feelsLike, tempMin, tempMax: Double
        let pressure, seaLevel, grndLevel, humidity: Int
        let tempKf: Double

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case seaLevel = "sea_level"
            case grndLevel = "grnd_level"
            case humidity
            case tempKf = "temp_kf"
        }
    }


    struct ForecastWeatherInfo: Codable {
        let id: Int
        let main: String
        let weatherDescription: String
        let icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }
}
