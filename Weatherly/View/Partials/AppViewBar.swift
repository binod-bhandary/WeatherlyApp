//
//  AppViewBAr.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI

//Define an eum for tab management with associated system image as raw value
enum Tab: String, CaseIterable {
    case currently = "sun.max" //the current weather view
    case today = "clock" //the daily detailed weather view
    case weekly = "calendar" // the weekly weather forecast view
}
//swift ui view that serves as a navigation bar with tab selection functionality
struct AppViewBar: View {
    @Binding var selectedTab: Tab // state binding to the current selected tab
    @Environment (\.colorScheme) var colorScheme // Environment property to adapt stype based on the system's color scheme
    
    func getTabName(tab: Tab) -> String {
        switch tab {
        case .currently:
            return "Currently"//show the name for current weather tab
        case .today:
            return "Today"//show the name fot the today tab
        case .weekly:
            return "Weekly"//show the name for the weekly forcast tab
        }
    }
    //Below is a loop through all cases of the tab enum to create tab items dynamically
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                        VStack(spacing: 6) {
                            Image(systemName: tab.rawValue)
                                .foregroundStyle(selectedTab == tab ? Color.white : .secondary)
                                .bold(selectedTab == tab)
                                .scaleEffect(1.25)
                                .font(.system(size: 16))
                                .onTapGesture {
                                        selectedTab = tab
                                }
                            Text(getTabName(tab: tab))
                                .foregroundStyle(selectedTab == tab ? Color.white : .secondary)
                                .bold()
                                .font(.system(size: 12))
                        }
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .frame(width: nil, height: 70)
        .background(colorScheme == .dark ? .black.opacity(0.5) : .white.opacity(0.5))
    }
}

//#Preview {
//    AppViewBar(selectedTab: .constant(.currently))
//}

#Preview {
    VStack {
        Spacer()
        AppViewBar(selectedTab: .constant(.currently))
        AppViewBar(selectedTab: .constant(.today))
        AppViewBar(selectedTab: .constant(.weekly))
    }
    .padding(.bottom, 16)
    .background(2/2 == 2/1
                ? LinearGradient(
                    gradient: Gradient(colors: [.purple.opacity(0.2), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                : LinearGradient(
                    gradient: Gradient(colors: [.purple.opacity(0.7), .indigo.opacity(0.8)]), startPoint: .top, endPoint: .bottom))
}
