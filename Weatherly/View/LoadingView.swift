//
//  LoadingView.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import SwiftUI

struct LoadingView: View {
    let weatherType: String? // Optional to allow different backgrounds
    var body: some View {
        ZStack {
              Image(weatherType ?? "sunny") // Use "sunny" as default
                .resizable()
                .ignoresSafeArea(.all)
                .opacity(0.3) // Adjust opacity for better visibility

              ProgressView()
                .progressViewStyle(.circular)
                .scaleEffect(2)

              VStack {
//                Image(systemName: weatherType?.map(getWeatherIcon) ?? "sun.max") // Use sun icon by default
                Image(systemName: "cloud") // Use sun icon by default
                  .resizable()
                  .scaledToFit()
                  .frame(width: 100, height: 100)
                Text("Loading weather data...")
                  .font(.title2)
                  .fontWeight(.light)
              }
        }
    }
    
    private func getWeatherIcon(_ type: String) -> String {
      switch type {
      case "cloudy":
        return "cloud"
      case "rainy":
        return "cloud.rain"
      case "snowy":
        return "snow"
      default:
        return "sun.max"
      }

    }
}

#Preview {
   LoadingView(weatherType: "sunny")
}
