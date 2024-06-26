//
//  TodayView.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI

//Defines a view that presents weather info for the current day
struct TodayView: View {
    var cityInfo: CityInfo?
    var body: some View {
        //Conditional rendering based on the availability of cityinfo
        if (cityInfo != nil) {
            ScrollView {
                VStack {
                    //Embeds the todaychart view which visualizes hourly weather data such as temperature
                    TodayChart(cityInfo: cityInfo, hourly: cityInfo?.hourly)
                    //Additional content that might include ohter weather details or forcast
                    ScrollViewContent()
                }
            }
        } else {
            Text("Unable to display the data. Please try again.")//fallback text displayed when no city info data is available
        }
      
    }
    
    // functions defined, it can determines the appropriate thermometer icon based on temperature
    
    func getTempLogo(temperature: Double) -> String {
        if (temperature > 25) {
            return ("thermometer.high")
        } else if (temperature > 15) {
            return ("thermometer.medium")
        } else {
            return ("thermometer.low")
        }
    }
    //This function returns the current hour as a string based on the provided timezone
    func getCurrentHour(timezone: String?) -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        if (timezone != nil) {
            dateFormatter.timeZone = TimeZone(identifier: timezone!)
        }
        let currentHourString = dateFormatter.string(from: currentDate)
        return currentHourString
    }
    //Determines if the current hour is the sunset hour
    func isSunsetHour(currentHour: String, sunsetTime: String?) -> Bool {
        guard let sunsetTime = sunsetTime else { return false }
        guard let sunsetHour = Int(sunsetTime.suffix(5).prefix(2)) else { return false }
        guard let currentHourInt = Int(currentHour) else { return false }
        if (currentHourInt == sunsetHour) {
            return true
        }
        return false
    }
    //Determine if the current hour is  sunrise hour
    func isSunriseHour(currentHour: String, sunriseTime: String?) -> Bool {
        guard let sunriseTime = sunriseTime else { return false }
        guard let sunriseHour = Int(sunriseTime.suffix(5).prefix(2)) else { return false }
        guard let currentHourInt = Int(currentHour) else { return false }
        if (currentHourInt == sunriseHour) {
            return true
        }
        return false
    }
    
    //Determine if it is currently night time based on sunset and sunrise time
    func isNight(currentHour: String, sunsetTime: String?, sunriseTime: String?) -> Bool {
        guard let sunsetTime = sunsetTime else { return false }
        guard let sunriseTime = sunriseTime else { return false }
        guard let sunsetHour = Int(sunsetTime.suffix(5).prefix(2)) else { return false }
        guard let sunriseHour = Int(sunriseTime.suffix(5).prefix(2)) else { return false }
        guard let currentHourInt = Int(currentHour) else { return false }
        
//        print("\(currentHour) - \(sunriseHour) - \(sunsetHour)")
        if (currentHourInt <= sunriseHour || sunsetHour < currentHourInt) {
            return true
        }
        return false
        
    }
    //A view builder function that creates additional scrollable content for the view
    @ViewBuilder
    func ScrollViewContent() -> some View {
        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                if (cityInfo?.hourly != nil) {
                    ForEach(0 ..< min(24, cityInfo!.hourly!.time.count), id: \.self) { i in
                        let currentHour = getCurrentHour(timezone: cityInfo!.city?.timezone)
                        let i_hour = String(cityInfo!.hourly!.time[i].suffix(5).prefix(2))
                        HStack {
                            VStack(spacing: 12) {
                                if (currentHour == i_hour) {
                                    Text("Now")
                                        .font(.system(size: 14, weight: .bold))
                                } else {
                                    Text("\(i_hour)h")
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                if (isNight(currentHour: String(i_hour), sunsetTime: cityInfo?.hourly?.sunset, sunriseTime: cityInfo?.hourly?.sunrise)) {
                                    MiniSceneView(sceneName: getWeatherInfo(weather_code: cityInfo!.hourly!.weather_code[i])?.nightModel ?? "")
                                        .frame(height: 40)
                                } else {
                                    
                                    MiniSceneView(sceneName: getWeatherInfo(weather_code: cityInfo!.hourly!.weather_code[i])?.dayModel ?? "")
                                        .frame(height: 40)
                                }
                                VStack(spacing: 4) {
                                    HStack(spacing: 4) {
                                        Image(systemName: getTempLogo(temperature: cityInfo!.hourly!.temperature_2m[i]))
                                            .font(.system(size: 14))
//                                            .opacity(0.8)
                                        Text("\(String(format: "%.1f", cityInfo!.hourly!.temperature_2m[i]))°")
                                            .font(.system(size: 14, weight: .bold))
//                                            .opacity(0.8)
                                    }
                                    HStack(spacing: 4) {
                                        Image(systemName: "wind")
                                            .font(.system(size: 14))
//                                            .opacity(0.8)
                                        Text("\(String(format: "%.1f", cityInfo!.hourly!.wind_speed_10m[i]))km/h")
                                            .font(.system(size: 14, weight: .light))
//                                            .opacity(0.8)
                                    }
                                }
                            }
                            .padding()
//                            cityInfo?.hourly?.sunrise
                            if (isSunriseHour(currentHour: String(i_hour), sunriseTime: cityInfo?.hourly?.sunrise)) {
                                VStack(spacing: 12) {
                                        Text("\(String(cityInfo!.hourly!.sunrise!.suffix(5)))")
                                            .font(.system(size: 14, weight: .bold))
                                        Image(systemName: "sunrise.fill")
                                            .foregroundStyle(.white, .orange)
                                            .font(.system(size: 28))
                                            .frame(height: 40)
                                        Text("Sunrise")
                                            .font(.system(size: 18, weight: .semibold))
                                            .frame(height: 40)
                                }
                                .padding()
                            }
                            if (isSunsetHour(currentHour: String(i_hour), sunsetTime: cityInfo?.hourly?.sunset)) {
                                VStack(spacing: 12) {
                                        Text("\(String(cityInfo!.hourly!.sunset!.suffix(5)))")
                                            .font(.system(size: 14, weight: .bold))
                                        Image(systemName: "sunset.fill")
                                            .foregroundStyle(.white, .orange)
                                            .font(.system(size: 28))
                                            .frame(height: 40)
                                        Text("Sunset")
                                            .font(.system(size: 18, weight: .semibold))
                                            .frame(height: 40)
                                }
                                .padding()
                            }
                        }
                    }
                }
            }
        }
        .background(.black.opacity(getOpacityByWeather(cityInfo: cityInfo)))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}
//sample data
#Preview {
    //    return ContentView()
    let jsonString = """
        {
            "city": {
                "id": 2988507,
                "name": "Paris",
                "latitude": 48.85341,
                "longitude": 2.3488,
                "elevation": 42,
                "timezone": "Europe/Paris",
                "country": "France",
                "admin1": "Île-de-France"
            },
            "current": {
                "time": "2024-04-04T11:30",
                "temperature_2m": 14.6,
                "is_day": 1,
                "weather_code": 95,
                "wind_speed_10m": 18.9
            },
            "hourly": {
                "time": ["2024-04-04T00:00", "2024-04-04T01:00", "2024-04-04T02:00", "2024-04-04T03:00", "2024-04-04T04:00", "2024-04-04T05:00", "2024-04-04T06:00", "2024-04-04T07:00", "2024-04-04T08:00", "2024-04-04T09:00",
                                  "2024-04-04T10:00", "2024-04-04T11:00", "2024-04-04T12:00", "2024-04-04T13:00", "2024-04-04T14:00",
                                  "2024-04-04T15:00", "2024-04-04T16:00", "2024-04-04T17:00", "2024-04-04T18:00", "2024-04-04T19:00",
                                  "2024-04-04T20:00", "2024-04-04T21:00", "2024-04-04T22:00", "2024-04-04T23:00",],
                "temperature_2m": [13.0, 7.8, 13.3, 13.2, 25, 26.7, 28.1, 29.5, 30.2, 31.8, 32.5, 32.9, 33.2, 33.5, 33.8, 33.9, 33.6, 33.2, 32.8, 32.5, 32.2,
                                                                                                                                    32.0, 31.8, 31.5, 31.2, 30.9, 30.6, 30.3, 30.0],
                "weather_code": [2, 61, 61, 61, 61, 61, 45, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 53, 61, 61, 61, 61, 61, 61, 61, 61, 86, 95],
                "wind_speed_10m": [18.2, 17.3, 18.7, 17.2, 19, 20.1, 21.5, 22.3, 23.6, 24.9, 25.3, 25.8, 26.2, 26.5, 26.7, 26.8, 26.6, 26.3, 26.0, 25.7, 25.4,
                                                                                                                                                                                                                                                                                                                                         25.1, 24.8, 24.5, 24.2, 23.9, 23.6, 23.3, 23.0],
                "sunrise": "2024-04-04T04:09",
                "sunset": "2024-04-04T18:09",
            },
            "daily": {
                "time": ["2024-04-04", "2024-04-05", "2024-04-06"],
                "weather_code": [80, 61, 3],
                "temperature_2m_max": [18.4, 17.2, 24.9],
                "temperature_2m_min": [12.0, 13.0, 12.1],
                "sunset": ["2024-04-04T04:09", "2024-04-05T04:09", "2024-04-04T06:09"],
                "sunrise": ["2024-04-04T18:09", "2024-04-05T18:09", "2024-04-06T18:09"],
            }
        }
        """
    guard let jsonData = jsonString.data(using: .utf8) else {
        // Handle the case where jsonString is nil or conversion fails
        print("Error converting jsonString to data")
        return Text("Invalid")
    }
    do {
        // Attempt JSON decoding
        let cityInfo = try JSONDecoder().decode(CityInfo.self, from: jsonData)
        return TodayView(cityInfo: cityInfo)
            .background(getRealBackground(cityInfo: cityInfo, weatherInfo: getWeatherInfo(weather_code: cityInfo.current?.weather_code), showSearchBar: false))
    } catch {
        // Handle decoding error
        print("Error decoding JSON:", error)
        return Text("Invalid previews")
    }
}
