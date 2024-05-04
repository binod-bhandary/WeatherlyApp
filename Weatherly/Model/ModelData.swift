//
//  ModelData.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import Foundation

// ModelData.swift
//This variable is a preview instance of the weather data loaded from a JSON file
var previewWeather: ResponseBody = load("weather.json")
//Generic function to load and decode a JSON file into a specified Decodable type
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    //Attempt to locate the JSON file within the main bundle
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")//error remind
    }
    //Attempts to load the data from the file
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")//error remind
    }
    //Attempts to decode the data into the specified Decodable type
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")//error remind
    }
}
