//
//  WeatherError.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

struct WeatherDataError: Decodable {
    let cod: Int
    let message: String
}
