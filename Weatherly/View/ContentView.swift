//
//  ContentView.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import SwiftUI

import SwiftUI
import CoreLocation

struct ContentView: View {
    
    
    // create an instance of LocationManager to manage location services
    @StateObject var locationManager = LocationManager()
    
    var weatherManager = WeatherManager()//this property stores an instance of WeatherManager which is responsible for fetching weather data
    @State var weather: ResponseBody?// the optional property that will hold the weather data when fetched successfully
    
    //layout setting
    var body: some View {
        VStack {
            //optional binding, will excute the block if location Manager has a valid location
            if let location = locationManager.location {
                if let weather = weather {//another optional binding, checks if weather data is available
                    WeatherView(weather: weather)
                } else {
                    LoadingView()//show a loading animation while weather data is being fetched
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)//fetch weather data asynchronously using tthe latitude and longitude
                            } catch {
                                print("Error getting weawther:\(error)")
                            }//if there is an error, pint it
                            
                        }
                }
            } else {
                //if no location is avaiable yet, this is for debug,because sometimes xcode may disable or not load the location
                if locationManager.isLoading {
                    LoadingView() //show loading animation while waiting for the location
                } else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
            
            
            
           
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }//set the background color of the vstack and set the color scheme of this view to dark mode
}


#Preview {
    ContentView()
}
