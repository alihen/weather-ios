//
//  ResponseHelper.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation

class ResponseHelper {

    class func handle<D: Decodable>(_ decode: D.Type, decoder: JSONDecoder = JSONDecoder(), result: Result<Data, APIError>, atKeyPath: String? = nil) -> Result<D, APIResponseError> {
        do {
            let data = try result.get()
            let output = try decoder.decode(decode, from: data)
            return .success(output)
        } catch let error as DecodingError {
            if
                decode == CurrentWeatherData.self,
                let test = try? result.get(),
                let errorOutput = try? decoder.decode(WeatherDataError.self, from: test) {
                return .failure(.customError(errorOutput.message))
            }
            return .failure(.decodingError(error))
        } catch {
            return .failure(.unknown(error))
        }
    }
}
