//
//  WeatherManager.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import Foundation
import CoreLocation

// **** not used ***
class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        // Hardcode for testing:
//        let testLatitude = -33.8679
//        let testLongitude = 151.2073

        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=xxx&units=metric") else {
            fatalError("Missing URL")
        }

        // Continue as before
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error fetching weather data")
        }
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        return decodedData
    }

}
