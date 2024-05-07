//
//  CurrentInfoDash.swift
//  Weatherly
//
//  Created by iMac on 5/5/2024.
//

import Foundation
import SwiftUI
//Defines a swiftui view that displays a dashboard for current weather info
struct CurrentInfoDash: View {

    var temp_high: Double?
    var temp_low: Double?
    var sun_rise: String?
    var sun_set: String?
    var wind_speed: Double?
    var humidity: Int8?
    var precipitation_probability: Int8?
    //The horizontal stack to arrange the labels and values in a row
    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            VStack(spacing: 8) {

                HStack(spacing: 4) {
                    Image(systemName: "wind")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Wind")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }

                if (wind_speed != nil) {
                    Text("\(String(format: "%.1f", (wind_speed!)))km/h")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .opacity(0.4)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .background(.white.opacity(0.8))
                .padding(.vertical)
            VStack(spacing: 8) {
                //humidity section
                HStack(spacing: 4) {
                    Image(systemName: "humidity")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Humidity")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }
                if (humidity != nil) {
                    Text("\(humidity!)%")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity)
            Divider()
                .background(.white.opacity(0.8))
                .padding(.vertical)
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "cloud.rain")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Rain")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }
                if (precipitation_probability != nil) {
                    Text("\(precipitation_probability!)%")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(height: 90)
        .background(.black.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding()
        // added
        HStack(alignment: .center) {
            Spacer()
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "sun.max.fill")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Temperature")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }
                if (temp_high != nil) {
                    Text("H\(String(format: "%.0f", (temp_high!)))°, L\(String(format: "%.0f", (temp_low!)))°")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .opacity(0.4)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .background(.white.opacity(0.8))
                .padding(.vertical)
            VStack(spacing: 8) {
                
                HStack(spacing: 4) {
                    Image(systemName: "sunrise.fill")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Sunrise")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }
                if (sun_rise != nil) {
                    Text("\(sun_rise!)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity)
            Divider()
                .background(.white.opacity(0.8))
                .padding(.vertical)
            VStack(spacing: 8) {
                HStack(spacing: 4) {
                    Image(systemName: "sunset.fill")
                        .font(.system(size: 14))
                        .opacity(0.8)
                    Text("Sunset")
                        .font(.system(size: 13, weight: .light))
                        .opacity(0.8)
                }
                if (sun_set != nil) {
                    Text("\(sun_set!)")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                } else {
                    Text("???")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                }
            }
            .frame(maxWidth: .infinity)
            Spacer()
        }
        .frame(height: 90)
        .background(.black.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding()
    }
}

#Preview {
//    return ContentView()
    VStack {
//        CurrentInfoDash(wind_speed: 18.9, humidity: 43, precipitation_probability: 74)
        CurrentInfoDash()
    }
    .preferredColorScheme(.dark)
    .background(LinearGradient(colors: [Color.indigo.opacity(0.2), Color.indigo.opacity(0.6)], startPoint: .top, endPoint: .bottom))
}
