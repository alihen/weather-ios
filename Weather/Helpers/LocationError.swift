//
//  LocationError.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/20.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case customError(String)

    var localizedDescription: String {
        switch self {
        case .customError(let message):
            return message
        }
    }
}
