## 3D Weatherly App

This Weather App provides users with real-time weather information, including current weather conditions, hourly forecasts for today, and weekly weather predictions. The app also includes additional features such as sunrise and sunset times, and the ability to share the user's location to get personalized weather updates.
This README file provides an overview of the 3D Weatherly app, which offers current, today's, and weekly weather forecasts visualized in a 3D environment.

### AUTHOR

**BINOD BHANDARY 25207046​**

**HONGYI LIANG 13345905​**

### Features

* **Current Weather:** Get real-time weather information for your current location, including temperature, feels like, humidity, wind speed, and weather description. Visualized in a 3D environment that reflects current conditions (e.g., rain showers might be depicted with rain falling in the 3D scene).
* **Today's Forecast:** See an hourly breakdown of the weather for the current day, allowing you to plan your day accordingly. Visualized within the 3D environment, potentially showing weather changes throughout the day.
* **Weekly Forecast:** View a summary of the weather forecast for the upcoming week, providing an overview of the general trends. Visualized in the 3D environment, potentially showcasing dominant weather patterns for the week.


## Features

- **Current Weather**: Displays the current weather conditions for the user's location.
- **Today Hourly Weather Predictions**: Provides hourly weather updates for the current day.
- **Weekly Weather Predictions**: Shows the weather forecast for the upcoming week.
- **Sunset and Sunrise**: Displays the times for sunrise and sunset for the user's location.
- **Share Location**: Allows users to share their location to receive accurate weather information.

## Technologies Used

- **SwiftUI**: For building the user interface.
- **CoreLocation**: For accessing the user's location.
- **Weather API**: For fetching real-time weather data.
- **Combine**: For handling asynchronous data streams.

## API Integration

This app uses a weather API to fetch real-time weather data. Follow these steps to set up the API:

1. Sign up for an  free API key from a weather service provider (e.g., OpenWeatherMap, WeatherAPI, meteo).
2. In the project, navigate to the `FetchApi.swift` file.

## Usage

### Current Weather

The `CurrentWeatherView` displays the current weather conditions, including temperature, weather description, and an icon representing the weather.

### Today Hourly Weather Predictions

The `HourlyWeatherView` provides a scrollable list of weather predictions for each hour of the current day.

### Weekly Weather Predictions

The `WeeklyWeatherView` displays the weather forecast for the upcoming week, including daily temperature highs and lows.

### Sunset and Sunrise

The `SunsetSunriseView` shows the times for sunrise and sunset based on the user's location.

### Sharing Location

The app uses `CoreLocation` to get the user's current location. Ensure you have the necessary permissions enabled in your `Info.plist` file:

```xml
<string>Geolocation pressed and cityLocation exist !.</string>
```

## Real-Time API Usage

The app uses the Combine framework to handle real-time data fetching from the weather API. Below is a simplified example of how data is fetched:

```swift
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
```

This example demonstrates how the app fetches weather data asynchronously and updates the UI in real-time.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Contact

For any questions or feedback, please reach out to [binod.bhandary@studen.uts.edu.au](mailto:binod.bhandary@studen.uts.edu.au).

---

Feel free to customize this README file according to your project's specific needs and details.
