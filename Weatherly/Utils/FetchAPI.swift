//
//  FetchAPI.swift
//  Weatherly
//
//  Created by iMac on 5/5/2024.
//

import Foundation

func fetchCityInfo(city: City) async -> CityInfo? {
    var cityInfo = CityInfo(city: city)
    var urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(city.latitude)&longitude=\(city.longitude)&current=temperature_2m,relative_humidity_2m,precipitation_probability,is_day,weather_code,wind_speed_10m&hourly=temperature_2m,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,sunrise,sunset"
    if (city.timezone != nil) {
        urlString += "&timezone=\(city.timezone!)"
    }
    guard let url = URL(string: urlString) else {
        print("This request has failed please try with an other URL...")
        return nil
    }
//    print(urlString)
    do {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("Invalid status code != 200")
            return nil
        }
        let decodedResponse = try JSONDecoder().decode(CityInfo.self, from: data)
        
        cityInfo.current = decodedResponse.current
        cityInfo.hourly = decodedResponse.hourly
        cityInfo.daily = decodedResponse.daily
        
        cityInfo.hourly?.sunrise = cityInfo.daily?.sunrise[0]
        cityInfo.hourly?.sunset = cityInfo.daily?.sunset[0]
        //        print("HERE !")
        return cityInfo
        
    } catch {
        print("Failed to fetch data")
    }
    
    return nil
}

func fetchCity(name: String) async -> [City] {
    //    print("0")
    DispatchQueue.main.async {
        LocationManager.shared.isFetchingCityList = true
    }
    let urlString = "https://geocoding-api.open-meteo.com/v1/search?name=\(name)&count=5&language=en&format=json"
//    print(urlString)
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
