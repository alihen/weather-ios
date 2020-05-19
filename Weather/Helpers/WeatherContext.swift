//
//  WeatherContext.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

enum WeatherContext: String, CaseIterable {
    case cloudy = "cloudy"
    case rainy = "rainy"
    case sunny = "sunny"

    var imageName: String {
        switch self {
        case .cloudy:
            return "coastal-cloudy"
        case .rainy:
            return "coastal-rainy"
        case .sunny:
            return "coastal-sunny"
        }
    }

    var color: UIColor {
        switch self {
        case .cloudy:
            return UIColor.coastalLightGrey
        case .rainy:
            return UIColor.coastalDarkGrey
        case .sunny:
            return UIColor.coastalBlue
        }
    }

    var forecastIconName: String {
        switch self {
        case .cloudy:
            return "forecast-cloudy"
        case .rainy:
            return "forecast-rainy"
        case .sunny:
            return "forecast-sunny"
        }
    }

    var titleYOffset: CGFloat {
        switch self {
        case .cloudy:
            return -50
        case .rainy:
            return -50
        case .sunny:
            return 0
        }
    }
}
