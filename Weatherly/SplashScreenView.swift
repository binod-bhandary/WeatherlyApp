//
//  SplashScreenView.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI
import SceneKit
struct SplashScreenView: View {
    @State private var isActive = false
    private let loadingTime: Double = 3.0
    @State private var loadingState = 0.0
    
    var body: some View {
        if (isActive) {
            ContentView()
        } else {
        ZStack(alignment: .center) {
            LinearGradient(
                gradient: Gradient(colors: [.purple.opacity(0.7), .indigo.opacity(0.9)]), startPoint: .top, endPoint: .bottom)
            VStack {
                    Text("WeatherlyApp")
                        .font(.system(size: 36, weight: .bold))
                        .italic()
                
                BasicLoadingUIViewRepresentable(sceneName: "partly_cloudy")
                    .frame(height: 250)
                // optional - need to hide
                    Text("Loading..")
                        .font(Font.custom("Baskerville-bold", size: 48))
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: 230, height: 12)
                            .opacity(0.4)
                            .border(Color.indigo, width: 2)
                        RoundedRectangle(cornerRadius: 16)
                            .frame(width: loadingState, height: 12)
                            .foregroundStyle(.purple)
                    }
                .onAppear {
                    while (loadingState < 230) {
                        withAnimation(.easeInOut(duration: loadingTime)) {
                            self.loadingState += 1
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + loadingTime) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    self.isActive = true
                }
            }
        }
      }
    }
}

#Preview {
    SplashScreenView()
}

