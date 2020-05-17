//
//  WeatherInfo.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

struct CurrentWeatherData: Decodable {
    let coord: WeatherCoordinates
    let weather: [WeatherMeta]
    let base: String
    let main: MainInfo
    let visibility: Int
    let wind: WindInfo
    let clouds: CloudInfo
    let timestamp: Int
    let sysInfo: SysInfo
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case coord, weather, base, main, visibility, wind, clouds
        case timestamp = "dt"
        case sysInfo = "sys"
        case id, name
    }

    struct CloudInfo: Decodable {
        let all: Int
    }

    struct WeatherCoordinates: Decodable {
        let lon, lat: Double
    }

    struct MainInfo: Decodable {
        let temp: Double
        let pressure, humidity: Int
        let tempMin, tempMax: Double

        enum CodingKeys: String, CodingKey {
            case temp, pressure, humidity
            case tempMin = "temp_min"
            case tempMax = "temp_max"
        }
    }

    struct SysInfo: Decodable {
        let type, id: Int
        let country: String
        let sunrise, sunset: Int
    }

    struct WeatherMeta: Decodable {
        let id: Int
        let main, weatherDescription, icon: String

        enum CodingKeys: String, CodingKey {
            case id, main
            case weatherDescription = "description"
            case icon
        }
    }

    struct WindInfo: Decodable {
        let speed: Double
        let deg: Int
    }
}
