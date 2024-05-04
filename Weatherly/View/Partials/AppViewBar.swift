//
//  AppViewBAr.swift
//  Weatherly
//
//  Created by iMac on 4/5/2024.
//

import SwiftUI


enum Tab: String, CaseIterable {
    case currently = "sun.max"
    case today = "clock"
    case weekly = "calendar"
}

struct AppViewBar: View {
    @Binding var selectedTab: Tab
    @Environment (\.colorScheme) var colorScheme
    
    func getTabName(tab: Tab) -> String {
        switch tab {
        case .currently:
            return "Currently"
        case .today:
            return "Today"
        case .weekly:
            return "Weekly"
        }
    }
    
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
