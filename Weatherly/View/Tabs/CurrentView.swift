//
//  CurrentView.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI

//Define a view to display current weather info for a given location
struct CurrentView: View {
    var cityInfo: CityInfo?//optional data containing weather and city details
    
    var body: some View {
        //Attempt to retrieve the weather info using the current weather code
        let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: cityInfo?.current?.weather_code ?? -1)
        //check if current weather data exists
        if (cityInfo?.current != nil) {
            ScrollView {
                VStack {
                    //Display the appropriate 3D model based on whether day or night
                    if (weatherInfo != nil) {
                        if (cityInfo?.current?.is_day == 0 && weatherInfo?.nightModel != nil) {
                            BasicLoadingUIViewRepresentable(sceneName: weatherInfo!.nightModel)
                                .frame(height: 300)
                        } else {
                            BasicLoadingUIViewRepresentable(sceneName: weatherInfo!.dayModel)
                                .frame(height: 300)
                        }
                    }
                    //Vertical stack to display temperature and weather description
                    VStack(spacing: 6) {
                        if (cityInfo?.current?.temperature_2m != nil) {
                            Text("\(String(format: "%.0f", cityInfo!.current!.temperature_2m))°")
                                .font(.system(size: 72))
                                .fontWeight(.bold)
                                .frame(height: 56)
                            //                            .background(.red)
                        }
                        if (cityInfo?.current?.weather_code != nil) {
                            Text("\(weatherInfo?.dayDescription ?? "")")
                                .font(.system(size: 18))
                                .fontWeight(.medium)
                        }
                    }
                    //            }
                    //subview to display detailed current weather data such as wind speed, humidity and precipitation probability
                    CurrentInfoDash(wind_speed: cityInfo?.current?.wind_speed_10m, humidity: cityInfo?.current?.relative_humidity_2m, precipitation_probability: cityInfo?.current?.precipitation_probability)
                    
                    //            Spacer()
                }
                //        .background(LinearGradient(colors: [Color.indigo.opacity(0.2), Color.indigo.opacity(0.6)], startPoint: .top, endPoint: .bottom))
                .ignoresSafeArea(.all)
            }
//            .background(getRealBackground(cityInfo: cityInfo, weatherInfo: getWeatherInfo(weather_code: cityInfo?.current?.weather_code), showSearchBar: false))
        } else {
            Text("Unable to display the data. Please try again.")
        }
    }
}

#Preview {
    CurrentView()
}
