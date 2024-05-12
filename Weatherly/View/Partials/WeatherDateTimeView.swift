//
//  WeatherDateTimeView.swift
//  Weatherly
//
//  Created by iMac on 12/5/2024.
//

import SwiftUI

struct WeatherDateTimeView: View {
        @State var curDateTime: Date
        var body: some View {
            VStack {
               Text("\(curDateTime, formatter: dateDayFormatter)")
                   .font(.title)
               HStack {
                   Text("\(curDateTime, formatter: timeFormatter)")
               }
           }
        }
}

#Preview {
    WeatherDateTimeView(curDateTime: Date())
}
