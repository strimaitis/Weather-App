//
//  CitiesData.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/9/23.
//

import SwiftUI

// Helper class for loading and storing data. Such data includes Cities, City, and Data types
class CitiesData {
    
    // Storing most recently searched city to fileURL
    private static func cityFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("city.data")
    }

    // Storing collection of cities previously searched to fileURL (called on deinit in SearchViewController)
    private static func citiesFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("cities.data")
    }

    // Storing city with current location to fileURL
    private static func locationFileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("location.data")
    }

    // Storing image data to variation of fileURL with unique iconString. New city with already stored image data with have access.
    private static func imageFileURL(_ iconString: String) throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(iconString).data")
    }

    static func loadCity(completion: @escaping (Result<City, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try cityFileURL()
                let fileData = try FileHandle(forReadingFrom: fileURL)
                let city = try JSONDecoder.shared.decode(City.self, from: fileData.availableData)
                completion(.success(city))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    static func loadCities(completion: @escaping (Result<Cities, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try citiesFileURL()
                let fileData = try FileHandle(forReadingFrom: fileURL)
                let cities = try JSONDecoder.shared.decode(Cities.self, from: fileData.availableData)
                completion(.success(cities))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    static func loadLocation(completion: @escaping (Result<City, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try locationFileURL()
                let fileData = try FileHandle(forReadingFrom: fileURL)
                let city = try JSONDecoder.shared.decode(City.self, from: fileData.availableData)
                completion(.success(city))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    static func loadIcon(iconString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try imageFileURL(iconString)
                let fileData = try FileHandle(forReadingFrom: fileURL)
                let data = try JSONDecoder.shared.decode(Data.self, from: fileData.availableData)
                    completion(.success(data))
            }
            catch {
                completion(.failure(error))
            }
        }
    }

    static func save(city: City, completion: ((Result<City, Error>) -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            guard let fileURL = try? cityFileURL() else {
                completion?(.failure(EncodingError.fileURL))
                return
            }
            JSONEncoder.shared.encode(city, fileURL: fileURL) { result in
                switch result {
                    case .success(let city):
                        completion?(.success(city))
                    case .failure(let error):
                        completion?(.failure(error))
                }
            }
        }
    }

    static func save(cities: Cities, completion: @escaping (Result<Cities, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let fileURL = try? citiesFileURL() else {
                completion(.failure(EncodingError.fileURL))
                return
            }
            JSONEncoder.shared.encode(cities, fileURL: fileURL) { result in
                switch result {
                    case .success(let cities):
                        completion(.success(cities))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }

    static func saveLocation(city: City, completion: @escaping (Result<City, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let fileURL = try? locationFileURL() else {
                completion(.failure(EncodingError.fileURL))
                return
            }
            JSONEncoder.shared.encode(city, fileURL: fileURL) { result in
                switch result {
                    case .success(let city):
                        completion(.success(city))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }

    static func saveIcon(data: Data, iconString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let fileURL = try? imageFileURL(iconString) else {
                completion(.failure(EncodingError.fileURL))
                return
            }
            JSONEncoder.shared.encode(data, fileURL: fileURL) { result in
                switch result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        completion(.failure(error))
                }
            }
        }
    }
}
