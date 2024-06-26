//
//  City.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import Foundation
import SwiftUI
import SceneKit


// city info
struct CityResult: Codable {
    var results: [City]
}

struct City: Codable {
    var id: Int
    var name: String
    var latitude: Double
    var longitude: Double
    var elevation: Int?
    var timezone: String?
    var country: String?
    var admin1: String? //  Région
}
//stored the detail info of city
struct CityInfo: Codable {
    var city: City?
    // CURRENT TAB
    var current: CurrentData?
    // TODAY TAB
    var hourly: HourlyData?
    var daily: WeeklyData?
    // WEEKLY TAB
    //    var weatherDateList: [Array<AnyObject>]
}
//current weather data structure
struct CurrentData: Codable {
    var time: String
    var temperature_2m: Double
    var is_day: Int8
    var weather_code: Int8
    var relative_humidity_2m: Int8?
    var precipitation_probability: Int8?
    var wind_speed_10m: Double
    var date: Date? { // Computed property to convert to Date
        time.isEmpty == false ? dateFormatter.date(from: time) : nil
    }
}
//hourly weather data structure
struct HourlyData: Codable {
    var time: Array<String>
    var temperature_2m: Array<Double>
    var weather_code: Array<Int8>
    var wind_speed_10m: Array<Double>
    var sunrise: String?
    var sunset: String?
}
//weekly weather data structure
struct WeeklyData: Codable {
    var time: Array<String>
    var weather_code: Array<Int8>
    var temperature_2m_min: Array<Double>
    var temperature_2m_max: Array<Double>
    var sunrise: Array<String>
    var sunset: Array<String>
}


//weather info and visual structure
struct WeatherInfo {
    let dayDescription: String
    let nightDescription: String
    let dayModel: String
    let nightModel: String
    let colorDay: [Color]
    let colorNight: [Color]
    let graphDayColor: Color
    let graphNightColor: Color
    let dayOpacity: Double
    let nightOpacity: Double
}

// 3d models that store the scnscense and name

let models3D: [String: SCNScene?] = [:]
//get the corresponding 3D model based on the scene name
func get3DModel(sceneName: String) -> SCNScene? {
    if let model = models3D[sceneName] {
        return model
    }
    return nil
}


// function based on the weather code to get the weather info and show it
func getWeatherInfo(weather_code: Int8?) -> WeatherInfo? {
    if (weather_code == nil) {
        return nil
    }
    return (WeatherMap.data["\(weather_code!)"] ?? nil)
}

//static data mapping, it will map weather codes to specific weatherInfo
struct WeatherMap {
    static let data: [String: WeatherInfo] = [
        "0": WeatherInfo(dayDescription: "Sunny", nightDescription: "Clear", dayModel: "sunny", nightModel: "clear_moon", colorDay: [.yellow.opacity(0.97), .yellow.opacity(0.95)], colorNight: [.indigo.opacity(0.5), .indigo.opacity(0.7)], graphDayColor: .yellow, graphNightColor: .indigo, dayOpacity: 0.45, nightOpacity: 0.3),
    
        "1": WeatherInfo(dayDescription: "Mainly Sunny", nightDescription: "Mainly Clear", dayModel: "sunny", nightModel: "clear_moon", colorDay: [.yellow.opacity(0.97), .yellow.opacity(0.95)], colorNight: [.indigo.opacity(0.5), .indigo.opacity(0.7)], graphDayColor: .yellow, graphNightColor: .indigo, dayOpacity: 0.45, nightOpacity: 0.3),
        
        "2": WeatherInfo(dayDescription: "Partly Cloudy", nightDescription: "Partly Cloudy", dayModel: "partly_cloudy", nightModel: "cloudy_night", colorDay: [.cyan, Color(red: 0.3, green: 0.35, blue: 1.0)], colorNight: [.indigo.opacity(0.5), .indigo.opacity(0.7)], graphDayColor: .blue, graphNightColor: .indigo, dayOpacity: 0.45, nightOpacity: 0.3),
        
        "3": WeatherInfo(dayDescription: "Cloudy", nightDescription: "Cloudy", dayModel: "cloudy", nightModel: "cloudy_night", colorDay: [.cyan, Color(red: 0.1627, green: 0.7392, blue: 1.0)], colorNight: [.indigo.opacity(0.5), .indigo.opacity(0.4)], graphDayColor: .blue, graphNightColor: .indigo, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "45":  WeatherInfo(dayDescription: "Foggy", nightDescription: "Foggy", dayModel: "cloudy", nightModel: "cloudy_fog", colorDay: [.gray, .gray.opacity(0.7)], colorNight: [.gray.opacity(0.5), .gray.opacity(0.3)], graphDayColor: .gray, graphNightColor: .gray, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "48": WeatherInfo(dayDescription: "Rime Fog", nightDescription: "Rime Fog", dayModel: "solo_snow", nightModel: "solo_snow", colorDay: [.white, .cyan], colorNight: [ .gray.opacity(0.3), .blue.opacity(0.6)], graphDayColor: .cyan, graphNightColor: .blue, dayOpacity: 0.4, nightOpacity: 0.3),
        
        "51": WeatherInfo(dayDescription: "Light Drizzle", nightDescription: "Light Drizzle", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.white.opacity(0.7), .white.opacity(0.5)], colorNight: [.white.opacity(0.3), .white.opacity(0.2)], graphDayColor: .white, graphNightColor: .white, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "53": WeatherInfo(dayDescription: "Drizzle", nightDescription: "Drizzle", dayModel: "heavy_rain", nightModel: "heavy_rain", colorDay: [.gray, .gray.opacity(0.5)], colorNight: [.gray.opacity(0.1), .blue.opacity(0.3)], graphDayColor: .gray, graphNightColor: .indigo, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "55": WeatherInfo(dayDescription: "Heavy Drizzle", nightDescription: "Heavy Drizzle", dayModel: "heavy_rain", nightModel: "heavy_rain", colorDay: [.gray.opacity(0.7), .gray.opacity(0.4)], colorNight: [.gray.opacity(0.2), .blue.opacity(0.2)], graphDayColor: .gray, graphNightColor: .blue.opacity(0.9), dayOpacity: 0.5, nightOpacity: 0.3),
        
        "56": WeatherInfo(dayDescription: "Light Freezing Drizzle", nightDescription: "Light Freezing Drizzle", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.white.opacity(0.7), .white.opacity(0.5)], colorNight: [.white.opacity(0.3), .white.opacity(0.2)], graphDayColor: .white, graphNightColor: .white, dayOpacity: 0.35, nightOpacity: 0.3),
        
        "57": WeatherInfo(dayDescription: "Freezing Drizzle", nightDescription: "Freezing Drizzle", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.white.opacity(0.8), .cyan], colorNight: [ .gray.opacity(0.3), .blue.opacity(0.4)], graphDayColor: .cyan, graphNightColor: .blue, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "61": WeatherInfo(dayDescription: "Light Rain", nightDescription: "Light Rain", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.cyan.opacity(0.8), Color(red: 0.1, green: 0.15, blue: 0.85)], colorNight: [.indigo.opacity(0.4), .blue.opacity(0.5)], graphDayColor: .blue, graphNightColor: .indigo, dayOpacity: 0.5, nightOpacity: 0.3),
        
        "63": WeatherInfo(dayDescription: "Rain", nightDescription: "Rain", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.cyan.opacity(0.8), Color(red: 0.1, green: 0.15, blue: 0.85)], colorNight: [.indigo.opacity(0.4), .blue.opacity(0.5)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.5, nightOpacity: 0.3),
             
        "65": WeatherInfo(dayDescription: "Heavy Rain", nightDescription: "Heavy Rain", dayModel: "heavy_rain", nightModel: "heavy_rain", colorDay: [.gray.opacity(0.3), .gray.opacity(0.2)], colorNight: [.gray.opacity(0.15), .gray.opacity(0.1)], graphDayColor: .gray, graphNightColor: .gray, dayOpacity: 0.5, nightOpacity: 0.3),
             
        "66": WeatherInfo(dayDescription: "Light Freezing Rain", nightDescription: "Light Freezing Rain", dayModel: "light_rain", nightModel: "light_rain", colorDay: [Color(red: 0.31, green: 0.35, blue: 0.65).opacity(0.8), .white.opacity(0.5)], colorNight: [.white.opacity(0.3), .white.opacity(0.2)], graphDayColor: .white, graphNightColor: .white, dayOpacity: 0.35, nightOpacity: 0.3),
             
        "67": WeatherInfo(dayDescription: "Freezing Rain", nightDescription: "Freezing Rain", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.white.opacity(0.7), .white.opacity(0.5)], colorNight: [.white.opacity(0.3), .white.opacity(0.2)], graphDayColor: .white, graphNightColor: .white, dayOpacity: 0.5, nightOpacity: 0.3),
             
        "71": WeatherInfo(dayDescription: "Light Snow", nightDescription: "Light Snow", dayModel: "snowfall", nightModel: "night_snowfall", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 247/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.4, nightOpacity: 0.3),
             
        "73": WeatherInfo(dayDescription: "Snow", nightDescription: "Snow", dayModel: "snowfall", nightModel: "night_snowfall", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 247/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.4, nightOpacity: 0.3),
             
        "75": WeatherInfo(dayDescription: "Heavy Snow", nightDescription: "Heavy Snow", dayModel: "heavy_snow", nightModel: "heavy_snow", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 227/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.4, nightOpacity: 0.3),
             
        "77": WeatherInfo(dayDescription: "Snow Grains", nightDescription: "Snow Grains", dayModel: "snowflake", nightModel: "snowflake", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 227/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .white, graphNightColor: .indigo, dayOpacity: 0.4, nightOpacity: 0.3),
 
        
        "80": WeatherInfo(dayDescription: "Light Showers", nightDescription: "Light Showers", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.cyan.opacity(0.8), Color(red: 0.1, green: 0.15, blue: 0.85)], colorNight: [.indigo.opacity(0.4), .blue.opacity(0.5)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.3, nightOpacity: 0.3),
                    
        "81": WeatherInfo(dayDescription: "Showers", nightDescription: "Showers", dayModel: "light_rain", nightModel: "light_rain", colorDay: [.cyan.opacity(0.8), Color(red: 0.1, green: 0.15, blue: 0.85)], colorNight: [.indigo.opacity(0.4), .blue.opacity(0.5)], graphDayColor: .cyan, graphNightColor: .indigo, dayOpacity: 0.3, nightOpacity: 0.3),

        
                    
        "82": WeatherInfo(dayDescription: "Heavy Showers", nightDescription: "Heavy Showers", dayModel: "heavy_rain", nightModel: "heavy_rain", colorDay: [.gray.opacity(0.3), .gray.opacity(0.2)], colorNight: [.gray.opacity(0.15), .gray.opacity(0.1)], graphDayColor: .white, graphNightColor: .gray, dayOpacity: 0.3, nightOpacity: 0.3),
        
                    
        "85": WeatherInfo(dayDescription: "Light Snow Showers", nightDescription: "Light Snow Showers", dayModel: "snowfall", nightModel: "night_snowfall", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 247/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .white, graphNightColor: .indigo, dayOpacity: 0.5, nightOpacity: 0.3),
        
                    
        "86": WeatherInfo(dayDescription: "Snow Showers", nightDescription: "Snow Showers", dayModel: "heavy_snow", nightModel: "heavy_snow", colorDay: [.white.opacity(0.9), Color(red: 120/255, green: 173/255, blue: 227/255)], colorNight: [.blue.opacity(0.2), Color(red: 120/255, green: 173/255, blue: 247/255).opacity(0.2)], graphDayColor: .white, graphNightColor: .indigo, dayOpacity: 0.4, nightOpacity: 0.3),
        
                    
        "95": WeatherInfo(dayDescription: "Thunderstorm", nightDescription: "Thunderstorm", dayModel: "thunderstorm", nightModel: "thunderstorm", colorDay: [.gray.opacity(0.2), .gray.opacity(0.3)], colorNight: [.black.opacity(0.1), .gray.opacity(0.15)], graphDayColor: .yellow, graphNightColor: .yellow, dayOpacity: 0.5, nightOpacity: 0.3),
        
                         
        "96": WeatherInfo(dayDescription: "Light Thunderstorms With Hail", nightDescription: "Light Thunderstorms With Hail", dayModel: "thunderstorm_with_hail", nightModel: "thunderstorm_with_hail", colorDay: [.gray.opacity(0.2), .gray.opacity(0.2)], colorNight: [.black.opacity(0.1), .gray.opacity(0.15)], graphDayColor: .yellow, graphNightColor: .yellow, dayOpacity: 0.5, nightOpacity: 0.3),
        
                         
        "99": WeatherInfo(dayDescription: "Thunderstorms With Hail", nightDescription: "Thunderstorms With Hail", dayModel: "big_thunderstorm_with_hail", nightModel: "big_thunderstorm_with_hail", colorDay: [.gray.opacity(0.15), .gray.opacity(0.15)], colorNight: [.black.opacity(0.1), .gray.opacity(0.10)], graphDayColor: .yellow, graphNightColor: .yellow, dayOpacity: 0.5, nightOpacity: 0.3),
    ]
}


//function to determine the appropriate background gradient based on weather info and UI context
func getRealBackground(cityInfo: CityInfo?, weatherInfo: WeatherInfo?, showSearchBar: Bool) -> LinearGradient {
    //check if the search bar is displayed
    if (showSearchBar) {
        //return a plain black gradient background when the search bar is active.
        //This provides a neutral background that does not distract from the search bar
        return LinearGradient(colors: [Color.black], startPoint: .center, endPoint: .center)
    } else if (weatherInfo != nil) {
        //check if the weather info is available and determine background gradient based on the time of day
        if (cityInfo?.current?.is_day == 0) {
            //If it is night,it use the night colors defined in the weather info for the background and this typically include darker, more subdued color
            return LinearGradient(colors: weatherInfo!.colorNight, startPoint: .top, endPoint: .bottom)
        } else {
            //If it is day, use the day colors defined in the weather info for the background, these are usually brighter and more vibrant to reflect daylight conditions
            return  LinearGradient(colors: weatherInfo!.colorDay, startPoint: .top, endPoint: .bottom)
        }
    } else {
        //If not specific weather info is available, return a default purple to gradient background. This default is used when no specific conditions are known to ensure the UI remains visually.
        return LinearGradient(
            gradient: Gradient(colors: [.purple.opacity(0.7), .indigo.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
    }
}
//function to determine the gradient colors for the graph based on the current weather condition
func getGradientGraph(cityInfo: CityInfo?) -> [Color] {
    //Attempt to fetch weather info based on the weather code in the city info
    let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: cityInfo?.current?.weather_code)
    //check if weather info is available
    if (weatherInfo == nil) {
        
        return [.white, .white.opacity(0.7), .white.opacity(0.05)]
    }
    //Returns a gradient array with colors from the weather info for daytime, adjusted for opacity
    if (cityInfo?.current?.is_day == 1) {
        return [weatherInfo!.graphDayColor, weatherInfo!.graphDayColor.opacity(0.7), weatherInfo!.graphDayColor.opacity(0.05)]
    } else {
        //If it is night, return a gradient array with colors from the weather info for night time adjusted for opacity
        return [weatherInfo!.graphNightColor, weatherInfo!.graphNightColor.opacity(0.7), weatherInfo!.graphNightColor.opacity(0.05)]
    }
}
//function to determine the appropriate line color for graphs based on the current weather condition
func getGraphLineColor(cityInfo: CityInfo?) -> Color {
    //Attempt to fetch weather info based on the weather code in the city info
    let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: cityInfo?.current?.weather_code)
    //check if weather info is available
    if (weatherInfo == nil) {
        //if no specific weather info available, return a default white color
        return .white
    }
    //Determine the time of day to select the appropriate color
    if (cityInfo?.current?.is_day == 1) {
        //if it is daytime, return the day graph color from the weather info
        return weatherInfo!.graphDayColor
    } else {
        //if it is nigh time, return the night graph color from the weather info
        return weatherInfo!.graphNightColor
    }
}


func getOpacityByWeather(cityInfo: CityInfo?) -> Double {
    //Attempts to fetch weather info based on the weather code in the city info
    let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: cityInfo?.current?.weather_code)
    //check if weather info is available
    if (weatherInfo == nil) {
        //if no specific weather info is available, return a default opacity 0.5
        return 0.5
    }
    //Determine the time of day to select the appropriate opacity
    if (cityInfo?.current?.is_day == 1) {
        //If it is daytime, return the day opacity from the weather info
        return weatherInfo!.dayOpacity
    } else {
        //Otherwise return the nigh opacity from the weather info
        return weatherInfo!.nightOpacity
    }
}
