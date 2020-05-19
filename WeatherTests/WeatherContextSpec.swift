//
//  WeatherContextSpec.swift
//  WeatherTests
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import Weather

class WeatherContextSpec: QuickSpec {

    override func spec() {
        describe("The WeatherContext enum") {
            it("should have the correct image names for each case") {
                for context in WeatherContext.allCases {
                    expect(context.imageName).to(equal("coastal-\(context.rawValue)"))
                }
            }

            it("should have the correct icons for each case") {
                for context in WeatherContext.allCases {
                    expect(context.forecastIconName).to(equal("forecast-\(context.rawValue)"))
                }
            }
        }
    }
}
