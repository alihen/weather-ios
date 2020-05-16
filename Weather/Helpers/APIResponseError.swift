//
//  APIResponseError.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

enum APIResponseError: Error {
    case customError(String)
    case decodingError(DecodingError)
    case unknown(Error)
}
