//
//  CurrentView.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI


struct CurrentView: View {
    var cityInfo: CityInfo?
    
    var body: some View {
        let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: cityInfo?.current?.weather_code ?? -1)
        
        if (cityInfo?.current != nil) {
            ScrollView {
                VStack {
                    if (weatherInfo != nil) {
                        if (cityInfo?.current?.is_day == 0 && weatherInfo?.nightModel != nil) {
                            BasicLoadingUIViewRepresentable(sceneName: weatherInfo!.nightModel)
                                .frame(height: 300)
                        } else {
                            BasicLoadingUIViewRepresentable(sceneName: weatherInfo!.dayModel)
                                .frame(height: 300)
                        }
                    }
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
                    CurrentInfoDash(
                        wind_speed: cityInfo?.current?.wind_speed_10m,
                        humidity: cityInfo?.current?.relative_humidity_2m,
                        precipitation_probability: cityInfo?.current?.precipitation_probability
                    )
                    
                    
                    
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
