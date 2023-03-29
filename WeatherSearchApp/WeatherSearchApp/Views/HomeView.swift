//
//  HomeView.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/9/23.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var homeModel: Home

    var body: some View {
        VStack {
            HStack {
                Image("HomePageIcon")
                Text("Welcome to the Weather app!").font(.largeTitle).bold()
            }
            Text("You can search for your city using the search icon in the top right corner")
            if let city = homeModel.currentLocation {
                WeatherHomeView(displayText: "Current Location", color: .green, city: city)
            }
            if let city = homeModel.lastSearchedCity {
                WeatherHomeView(displayText: "Last Searched City", color: .yellow, city: city)
            }
            Spacer()
        }.onAppear {
            loadLocalWeather()
            loadLastCity()
        }
        .padding()
    }

    private func loadLastCity() {
        CitiesData.loadCity { result in
            switch result {
                case .success(let city):
                    DispatchQueue.main.async {
                        homeModel.lastSearchedCity = city
                    }

                    city.getImageData { data in
                        DispatchQueue.main.async {
                            if let data {
                                city.imageData = data
                            }
                        }
                    }
                default:
                    break
            }
        }
    }

    private func loadLocalWeather() {
        CitiesData.loadLocation { result in
            switch result {
                case .success(let city):
                    DispatchQueue.main.async {
                        homeModel.currentLocation = city
                    }

                    city.getImageData { data in
                        DispatchQueue.main.async {
                            if let data {
                                city.imageData = data
                            }
                        }
                    }
                default:
                    break
            }
        }
    }
}

struct WeatherHomeView: View {
    var displayText: String
    var color: Color
    var city: City

    var body: some View {
        VStack {
            Text(displayText).font(.largeTitle).bold()
            WeatherView(city: city)
        }
        .background(color)
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(homeModel: Home())
    }
}
