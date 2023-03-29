//
//  Double+Extension.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/9/23.
//

import Foundation

extension Double {
    func getTemperatureFromLocale() -> String {
        let temp = Measurement<UnitTemperature>(value: self, unit: .kelvin)
        return temp.formatted()
    }
}
