//
//  WeeklyChart.swift
//  Weatherly
//
//  Created by iMac on 5/5/2024.
//

import SwiftUI
import Charts

//A structure to hold daily chart data include the min and max temperature
struct ChartDayData {
    var id = UUID()
    var time: String
    var timeDate: Date
    var temperature_2m_min: Double
    var temperature_2m_max: Double
}
//function to convert a time string into a date object
func convertToDate(timeString: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
    
    let date = dateFormatter.date(from: timeString)!
    return date
}
//function to transform weekly data into a format suitable for charting
func weeklyToChartsData(weekly: WeeklyData?) -> [ChartDayData] {
    var chartDataArray: [ChartDayData] = []
    //Ensure weekly data is available and limit the loop to 24 entries or the count of days
    for i in 0 ..< min(24, weekly!.time.count) {
        //create a chartdaydata object for each day
        let chartData = ChartDayData(time: weekly!.time[i], timeDate: convertToDate(timeString: weekly!.time[i]), temperature_2m_min: weekly!.temperature_2m_min[i], temperature_2m_max: weekly!.temperature_2m_max[i])
        chartDataArray.append(chartData)//append to the array
    }
    return chartDataArray
}

var dateFormatter: DateFormatter {
    let    formatter = DateFormatter()
           formatter.dateFormat = "dd/MM"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}
var dateDayFormatter: DateFormatter {
    let    formatter = DateFormatter()
           formatter.dateFormat = "EEEE MMMM dd"
           formatter.locale = Locale(identifier: "en_US_POSIX")
           formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}
struct WeeklyChart: View {
    
    var cityInfo: CityInfo?
    var weekly: WeeklyData?

    var body: some View {
        let chartsData: [ChartDayData] = weeklyToChartsData(weekly: self.weekly)//convert weekly data to chart data

        VStack(spacing: 2) {
            Text("Weekly temperatures")
                .font(.system(size: 16, weight: .light, design: .rounded))
                .opacity(0.7)
                .padding(.top)
            Chart {
                ForEach(chartsData, id: \.id) { chartDay in
                    LineMark(
                        x: .value("Day", chartDay.timeDate, unit: .day),
                        y: .value("Max", chartDay.temperature_2m_max),
                        series: .value("max", "Max temperature")
                    )
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.orange.gradient)
                    .foregroundStyle(by: .value("max", "Max temperature"))
                    
                    .symbol {
                        Circle()
                            .fill(.white)
                            .frame(width: 4)
                    }
                    //Line mark for min temperature
                    LineMark(
                        x: .value("Day", chartDay.timeDate, unit: .day),
                        y: .value("Min", chartDay.temperature_2m_min),
                        series: .value("min", "Min temperature")
                    )
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(Color.blue.gradient)
                    .foregroundStyle(by: .value("min", "Min temperature"))
                    .symbol {
                        Circle()
                            .fill(.white)
                            .frame(width: 4)
                    }
                }
                
            }
            .frame(height: 250)
            .chartLegend(position: .bottom, alignment: .center, spacing: 24) {
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Circle()
                            .fill(.orange)
                            .frame(width: 6)
                        Text("Max temperature")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundStyle(.white).opacity(0.5)
                    }
                    HStack(spacing: 4) {
                
                        Circle()
                            .fill(.blue)
                            .frame(width: 6)
                        Text("Min temperature")
                            .font(.caption2)
                            .fontWeight(.light)
                            .foregroundStyle(.white).opacity(0.5)
                    }
                    
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { axisValue in
                    if let date = axisValue.as(Date.self) {
                        AxisValueLabel(centered: true, multiLabelAlignment: .center) {
                            
                            if (axisValue.index == 7) {
                                Text("").font(.system(size: 8))
                            }
                            Text("\(date, formatter: dateFormatter)").font(.system(size: 8))
                        }
                    }
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                    AxisGridLine(centered: false, stroke: StrokeStyle(lineWidth: 0.5, dash: [2]))
                }
                
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic(desiredCount: 8)) { value in
                    AxisValueLabel {
                        if let _temperature = value.as(Double.self) {
                            Text("\(_temperature.formatted())°C")
                        }
                    }
                    
                    AxisTick(stroke: StrokeStyle(lineWidth: 0))
                    
                    AxisGridLine(centered: false, stroke: StrokeStyle(lineWidth: 0.5, dash: [5]))
                }
            }
            .padding()
        }
        .background(Color.black.opacity(getOpacityByWeather(cityInfo: cityInfo)))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}
//Below is a sample preview setup to visualize the component
#Preview {
    
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
                "weather_code": 80,
                "wind_speed_10m": 18.9
            },
            "hourly": {
                "time": ["2024-04-04T00:00", "2024-04-04T01:00", "2024-04-04T02:00", "2024-04-04T03:00", "2024-04-04T04:00", "2024-04-04T05:00", "2024-04-04T06:00", "2024-04-04T07:00", "2024-04-04T08:00", "2024-04-04T09:00",
                                  "2024-04-04T10:00", "2024-04-04T11:00", "2024-04-04T12:00", "2024-04-04T13:00", "2024-04-04T14:00",
                                  "2024-04-04T15:00", "2024-04-04T16:00", "2024-04-04T17:00", "2024-04-04T18:00", "2024-04-04T19:00",
                                  "2024-04-04T20:00", "2024-04-04T21:00", "2024-04-04T22:00", "2024-04-04T23:00",],
                "temperature_2m": [13.0, 7.8, 13.3, 13.2, 25, 26.7, 28.1, 29.5, 30.2, 31.8, 32.5, 32.9, 33.2, 33.5, 33.8, 33.9, 33.6, 33.2, 32.8, 32.5, 32.2,
                                                                                                                                    32.0, 31.8, 31.5, 31.2, 30.9, 30.6, 30.3, 30.0],
                "weather_code": [2, 61, 61, 61, 61, 61, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32],
                "wind_speed_10m": [18.2, 17.3, 18.7, 17.2, 19, 20.1, 21.5, 22.3, 23.6, 24.9, 25.3, 25.8, 26.2, 26.5, 26.7, 26.8, 26.6, 26.3, 26.0, 25.7, 25.4,
                                                                                                                                                                                                                                                                                                                                         25.1, 24.8, 24.5, 24.2, 23.9, 23.6, 23.3, 23.0]
            },
            "daily": {
                "time": ["2024-04-04", "2024-04-05", "2024-04-06", "2024-04-07", "2024-04-08", "2024-04-09", "2024-04-10"],
                "weather_code": [80, 61, 3, 45, 80, 45, 45],
                "temperature_2m_max": [18.4, 17.2, 24.9, 16.4, 14.6, 17.7, 29.0],
                "temperature_2m_min": [12.0, 13.0, 12.1, 12, 5.0, -3, 23.8]
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
        return WeeklyView(cityInfo: cityInfo)
                .background(LinearGradient(
                gradient: Gradient(colors: [.purple.opacity(0.2), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
    } catch {
        // Handle decoding error
        print("Error decoding JSON:", error)
        //return Text("Invalid previews")
        return Text("Error: \(error.localizedDescription)").foregroundColor(.red)
    }
}
