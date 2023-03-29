//
//  String+Extension.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/10/23.
//

import Foundation

extension String {
    func getFormattedJSONParameter() -> String {
        return self.replacingOccurrences(of: " ", with: "%20")
    }
}
