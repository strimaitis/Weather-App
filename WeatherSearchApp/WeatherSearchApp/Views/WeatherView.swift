//
//  WeatherView.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/8/23.
//

import SwiftUI

struct WeatherView: View {
    @ObservedObject var city: City

    var body: some View {
        VStack {
            HeaderView(city: city)
        }
    }
}

struct HeaderView: View {
    @ObservedObject var city: City

    var body: some View {
        HStack {
            Spacer()
            if let imageData = city.imageData, let image = UIImage(data: imageData) {
                Image(uiImage: image).resizable().scaledToFill().frame(width: 120.0, height: 120.0)
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(city.name)").font(.largeTitle)
                    }
                    HStack {
                        Text(city.main.temp.getTemperatureFromLocale())
                        Text("(\(city.main.temp_min.getTemperatureFromLocale()) low / \(city.main.temp_max.getTemperatureFromLocale()) high)")
                    }
                    HStack {
                        Text(city.weather.first?.main ?? "")
                    }
                }.padding()
            } else {
                ProgressView().frame(width: 120.0, height: 120.0)
            }
            Spacer()
        }
    }
}

/*
struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(city: nil)
    }
}
*/
