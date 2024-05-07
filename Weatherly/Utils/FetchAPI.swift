//
//  FetchAPI.swift
//  Weatherly
//
//  Created by iMac on 5/5/2024.
//

import Foundation
//Asynchronously fetches detailed weather info for a specifiyed city using its geographical coordinates
func fetchCityInfo(city: City) async -> CityInfo? {
    //initialize a city info object with basic city data
    var cityInfo = CityInfo(city: city)
    //Construct the request url with parameters for weather data
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,relative_humidity_2m,precipitation_probability,is_day,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset"
    //append timezone to the url if available
    if (city.timezone != nil) {
        urlString += "&timezone=\(city.timezone!)"
    }
    //validate the URL
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        return nil
    }
//    print(urlString) and try to perform the API request
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            return nil
        }
        //decode the JSON response into the city info structure
        let decodedResponse = try JSONDecoder().decode(CityInfo.self, from: data)
        //update city info with fetched weather data
        cityInfo.current = decodedResponse.current
        cityInfo.hourly = decodedResponse.hourly
        cityInfo.daily = decodedResponse.daily
        //Adjust sunrise and sunset time based on the daily data
        cityInfo.hourly?.sunrise = cityInfo.daily?.sunrise[0]
        cityInfo.hourly?.sunset = cityInfo.daily?.sunset[0]
        //        print("HERE !")
        return cityInfo
        
    } catch {
        print("Failed to fetch data")
    }
    
    return nil
}
//Asynchronously fetches a list of cities based on the search query using a geocoding API
func fetchCity(name: String) async -> [City] {
    //    print("0") indicate that the city list is being fetched
    DispatchQueue.main.async {
        LocationManager.shared.isFetchingCityList = true
    }
    //consturct the request URL
    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=5&language=en&format=json"
    // Create URL
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        DispatchQueue.main.async {
            LocationManager.shared.isFetchingCityList = false
        }
        return []
    }
    
    // Fetch data from the URL
    do {
        //        print("1")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            LocationManager.shared.isFetchingCityList = false
            return []
        }
        //        print("2")
        // decode the data
        let decodedResponse = try JSONDecoder().decode(CityResult.self, from: data)
        //        print("3")
        //        print(decodedResponse.results)
        DispatchQueue.main.async {
            LocationManager.shared.isFetchingCityList = false
        }
        return decodedResponse.results
    } catch {
        print("Failed to fetch the data : \(error)")
        DispatchQueue.main.async {
            LocationManager.shared.isFetchingCityList = false
        }
        return []
    }
}
