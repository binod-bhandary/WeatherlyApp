//
//  Responses.swift
//  Weatherly
//
//  Created by iMac on 30/4/2024.
//

import Foundation
//Define a struct to decode the json
struct ResponseBody: Decodable {
        var coord: CoordinatesResponse //hold the geographical coordinates (longitude and latitude)
        var weather: [WeatherResponse] //an array of weather conditions (could include more than one element for different times of the day
        var main: MainResponse //main weather data like temperature and humidity
        var name: String //name of location
        var wind: WindResponse // wind speed and direction
    struct CoordinatesResponse: Decodable {
            var lon: Double
            var lat: Double
        }
    //nested struct for decoding weather details from JSON
    struct WeatherResponse: Decodable {
            var id: Double
            var main: String // group of weather parameters(Rain, Snow, and others)
            var description: String
            var icon: String //weather icon id
        }
    struct MainResponse: Decodable {
            var temp: Double // temperature
            var feels_like: Double //human perception of weather
            var temp_min: Double // min temperature
            var temp_max: Double// max temperature
            var pressure: Double
            var humidity: Double
        }
    struct WindResponse: Decodable {
            var speed: Double
            var deg: Double
        }
}
//extension of MainResponse to provided computed properties for easier access
extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
