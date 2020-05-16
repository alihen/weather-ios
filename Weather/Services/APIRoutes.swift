//
//  APIRoutes.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/14.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

/// A protocol allowing us to define our API endpoints.
protocol APIDefinition {
    var scheme: String { get }
    var host: String { get }
    var rootPath: String { get }
    var path: String { get }
    var parameters: [URLQueryItem] { get }
    var headers: [String: String] { get }
}

enum WeatherAPIRoute {
    case currentWeather(String)
    case forecast(String)
}

extension WeatherAPIRoute: APIDefinition {
    var scheme: String {
        return "https"
    }

    var host: String {
        return "api.openweathermap.org"
    }

    var rootPath: String {
        return "/data/2.5/"
    }

    var path: String {
        switch self {
        case .currentWeather:
            return "weather"
        case .forecast:
            return "forecast"
        }
    }

    var parameters: [URLQueryItem] {
        switch self {
        case .currentWeather(let query), .forecast(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "api-key", value: "")
            ]
        }
    }

    var headers: [String : String] {
        return [:]
    }
}
