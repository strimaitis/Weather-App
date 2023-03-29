//
//  JSON+Extension.swift
//  WeatherSearchApp
//
//  Created by Matthew Strimaitis on 3/8/23.
//

import Foundation

// Custom DecodingError enum
enum DecodingError: Error {
    case url
}

// Custom EncodingError enum
enum EncodingError: Error {
    case fileURL
}

extension JSONDecoder {
    static var shared = JSONDecoder()

    /** DECODE
     - parameters:
        - type: The data type to be decoded
        - urlString: The string to convert to URL
        - completion: Escaping completion handler to handle success, failure condition
     */
    func decode<T: Decodable>(_ type: T.Type, urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            // Invalid URL
            completion(.failure(DecodingError.url))
            return
        }
        decode(type, url: url, completion: completion)
    }

    /** DECODE
     - parameters:
        - type: The data type to be decoded
        - url: The URL to convert to Data
        - completion: Escaping completion handler to handle success, failure condition
     */
    func decode<T: Decodable>(_ type: T.Type, url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let data = try Data(contentsOf: url)
            do {
                let result = try self.decode(type, from: data)
                completion(.success(result))
            } catch {
                // Decoding failure
                completion(.failure(error))
            }
        }
        catch {
            // Invalid Data from URL
            completion(.failure(error))
        }
    }
}



extension JSONEncoder {
    static var shared = JSONEncoder()

    /** ENCODE
     - parameters:
        - type: The data type to be encoded
        - fileURL: The filepath to write the Data to
        - completion: Escaping completion handler to handle success, failure condition
     */
    func encode<T: Encodable>(_ type: T, fileURL: URL, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let data = try encode(type)
            try data.write(to: fileURL)
            completion(.success(type))
        }
        catch {
            // Failure trying to encode or write data
            completion(.failure(error))
        }
    }
}
