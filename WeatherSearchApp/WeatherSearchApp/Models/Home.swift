//
//  Home.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/10/23.
//

import SwiftUI

// Model for HomeView to store last searched city and shared location, ObservableObject to update SwiftUI
class Home: ObservableObject {
    @Published var lastSearchedCity: City?
    @Published var currentLocation: City?
}
