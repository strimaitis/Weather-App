//
//  City.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/7/23.
//

import Foundation

// Primary City Class. ObservableObject to update SwiftUI, Codable for JSON encoding + decoding
class City: ObservableObject, Codable {
    enum CodingKeys: CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
    }

    let coord: Coordinates
    let weather: [Weather]
    let base: String
    let main: Main
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: System
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int

    @Published var imageData: Data?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        coord = try container.decode(Coordinates.self, forKey: .coord)
        weather = try container.decode([Weather].self, forKey: .weather)
        base = try container.decode(String.self, forKey: .base)
        main = try container.decode(Main.self, forKey: .main)
        visibility = try container.decode(Int.self, forKey: .visibility)
        wind = try container.decode(Wind.self, forKey: .wind)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        dt = try container.decode(Int.self, forKey: .dt)
        sys = try container.decode(System.self, forKey: .sys)
        timezone = try container.decode(Int.self, forKey: .timezone)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cod = try container.decode(Int.self, forKey: .cod)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(coord, forKey: .coord)
        try container.encode(weather, forKey: .weather)
        try container.encode(base, forKey: .base)
        try container.encode(main, forKey: .main)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(wind, forKey: .wind)
        try container.encode(clouds, forKey: .clouds)
        try container.encode(dt, forKey: .dt)
        try container.encode(sys, forKey: .sys)
        try container.encode(timezone, forKey: .timezone)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(cod, forKey: .cod)
    }

    
}

extension City {
    func getImageData(completion: @escaping (Data?) -> Void) {
        guard let iconString = self.weather.first?.icon else {
            completion(nil)
            return
        }
        // Load preloaded image by icon name
        CitiesData.loadIcon(iconString: iconString) { result in
            switch result {
                case .success(let data):
                    completion(data)
                case .failure(_):
                    // If image isn't loaded make service call, save image by name
                    DispatchQueue.global(qos: .userInteractive).async {
                        if let url = self.weather.first?.iconURL, let data = try? Data(contentsOf: url) {
                            CitiesData.saveIcon(data: data, iconString: iconString) { _ in
                            }
                            completion(data)
                        }
                    completion(nil)
                }
            }
            
        }
    }
}

struct Clouds: Codable {
    let all: Int
}

struct Coordinates: Codable {
    let lon: Float
    let lat: Float
}

struct Main: Codable {
    let temp: Double
    let feels_like: Float
    let temp_min: Double
    let temp_max: Double
    let pressure: Float
    let humidity: Float
}

struct System: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String

    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/w/\(icon).png")
    }
}

struct Wind: Codable {
    let speed: Float
    let deg: Float
}
