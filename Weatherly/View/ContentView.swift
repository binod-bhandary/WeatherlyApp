//
//  ContentView.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import SwiftUI
import CoreLocationUI
struct ContentView: View {
    @State private var cities = [City]()
    @State private var searchText = ""
    // Search bar state
    @State private var showSearchBar = false
    @State private var searchBarNoAnimation = false
    @State private var noSearchMatchingAnimation = false
    @FocusState private var focusedSearch: Bool?
    
    @State private var selectedTab: Tab = .currently
    @Environment (\.colorScheme) var colorScheme
    @ObservedObject var locationManager = LocationManager.shared
    

    @State private var cityName : String = "-"
    @State private var cityCountry : String = "-"
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func cancelSearchLocation() -> Void {
        hideKeyboard()
        // Wait for the keyboard to hide before performing animation
        searchBarNoAnimation = false
        withAnimation(.easeInOut(duration: 0.1)) {
            showSearchBar = false
        }
        focusedSearch = false
    }

    
    var body: some View {
        let weatherInfo: WeatherInfo? = getWeatherInfo(weather_code: LocationManager.shared.cityInfo?.current?.weather_code ?? -1)
        VStack(spacing: 0) {
            // HEADER
            HStack {
                // TITLE
                if (showSearchBar == false) {
                    VStack(spacing: 1) {
                        Text(cityName)
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundStyle(colorScheme == .dark ? .white : .black)
                        Text(cityCountry)
                            .font(.title3)
                    }
                    Spacer()
                }
                
                // LOC SEARCH
                HStack {
                    if (showSearchBar) { // The search bar
                        Image(systemName: "magnifyingglass")
                        TextField("Search location", text: $searchText)
                            .focused($focusedSearch, equals: true)
                            .onSubmit {
                                hideKeyboard()
                            }
                            .onChange(of: focusedSearch) { newValue in
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    noSearchMatchingAnimation = newValue ?? false
                                }
                            }
                            .onChange(of: searchText) { newValue in
                                if (searchText.isEmpty == false) {
                                    Task {
                                        
                                        let fetchedCities = await fetchCity(name: searchText)
                                        DispatchQueue.main.async {
                                            cities = fetchedCities
                                        }
                                    }
                                    
                                } else {
                                    DispatchQueue.main.async {
                                        cities = []
                                    }
                                }
                            }
                        Button(action: {
                            if (searchText.isEmpty == false) {
                                searchText = ""
                            } else {
                                cancelSearchLocation()
                            }
                        }, label: {
                            if (searchText.isEmpty == false) {
                                
                                Image(systemName: "xmark")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            } else {
                                Text("Cancel")
                                    .font(.subheadline)
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                            }
                        })
                    } else {
                        
                        HStack {
                            Button(action: {
                                searchBarNoAnimation = true
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    searchText = ""
                                    showSearchBar = true
                                    focusedSearch = true
                                }
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(10)
                                    .bold()
                            })
                            Button(action: {
                                locationManager.requestLocation()
                                if (locationManager.cityLocation != nil) {
                                    print("Geolocation pressed and cityLocation exist !")
                                    Task {
                                        let cityInfoFetching = await fetchCityInfo(city: locationManager.cityLocation!)
                                        locationManager.cityInfo = cityInfoFetching
                                    }
                                } else {
                                    print("Geolocation pressed but cityLocation not exist !")
                                }
                            }, label: {
                                Image(systemName: "location")
                                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                                    .padding(10)
                                    .bold()
                            })
                        }
                    }
                }
                .padding(showSearchBar ? 10 : 0)
                //                .background(Color.white.opacity(0.1))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.1))
                        .shadow(color: .black, radius: 6, x: 2, y: 2)
                    
                )
                //                .cornerRadius(20)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            .padding(.bottom, 12)
            .background(searchBarNoAnimation ? Color.primary.opacity(colorScheme == .dark ? 0.1 : 0.25) : Color.clear)
            
            if (searchBarNoAnimation) {
                GeometryReader(content: { geometry in
                    if (searchText.isEmpty || searchText.count == 1) {
                        VStack {
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(colorScheme == .dark ? .black : .white)
                    } else if (cities.count == 0 && searchText.count > 1) {
                        VStack(spacing: 12) {
                            Spacer()
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.gray)
                                .font(.system(size: 48))
                            VStack(spacing: 2) {
                                Text("**No Results**")
                                    .font(.title2)
                                Text("No results found for \"\(searchText)\".")
                                    .foregroundStyle(.gray)
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .frame(width: geometry.size.width, height: (noSearchMatchingAnimation) ? geometry.size.height / 2 : geometry.size.height)
                        .background(colorScheme == .dark ? .black : .white)
                    } else {
                        List(cities, id: \.id) { city in
                            Button(action: {
                                print("\(city.id) : \(city.longitude) | \(city.latitude)")
                                searchText = ""
                                
                                locationManager.cityLocation = city
                                if (locationManager.cityLocation != nil) {
                                    Task {
                                        locationManager.isFetchingCityInfo = true
                                        let cityInfoFetching = await fetchCityInfo(city: locationManager.cityLocation!)
                                        locationManager.cityInfo = cityInfoFetching
                                        locationManager.isFetchingCityInfo = false
                                    }
                                    
                                } else {
                                    print("Invalid City")
                                }
                                focusedSearch = false
                                hideKeyboard()
                                searchBarNoAnimation = false
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    showSearchBar = false
                                }
                            }) {
                                HStack(spacing: 0) {
                                    Image(systemName: "building.2")
                                        .padding(.trailing, 16)
                                    Text("**\(city.name)**")
                                    + Text((city.admin1 != nil) ? " \(city.admin1!)" : "")
                                    + Text((city.country != nil) ? ", \(city.country!)" : "")
                                    
                                }
                            }
                            .foregroundStyle(.primary)
                        }
                    }
                })
            }
            else {
                // set city info values
                if (locationManager.isFetchingCityInfo == false && locationManager.cityInfo != nil) {
                    WeatherDateTimeView(curDateTime: locationManager.cityInfo?.current?.date ?? Date())
                       .onAppear {
                          cityName = locationManager.cityInfo?.city?.name ?? "-"
                          cityCountry = (locationManager.cityInfo?.city?.admin1 ?? "Unknown") + ", " + (locationManager.cityInfo?.city?.country ?? "Unknown")
                      }
                 }
                
                
                
                TabView(selection: $selectedTab) {
                    if (locationManager.isFetchingCityInfo == false) {
                        if (locationManager.cityLocation != nil && locationManager.cityInfo != nil) {
                           
                            CurrentView(cityInfo: locationManager.cityInfo)
                                .navigationTitle("Currently")
                                .tabItem {
                                    VStack {
                                        Image(systemName: "sun.min")
                                        Text("Currently")
                                    }
                                }
                                .tag(Tab.currently)
                            
                        } else {
                            if (locationManager.cityLocation == nil) {
//                                Text("Geolocation is not available, please enable it in your App settings.")
//                                    .multilineTextAlignment(.center)
//                                    .padding()
//                                    .tag(Tab.currently)
                                
                                LocationButton(.shareCurrentLocation) {
                                    locationManager.requestLocation()
                                }
                                .cornerRadius(30)
                                .symbolVariant(.fill)
                                .foregroundColor(.white)
                                
                            } else if (locationManager.cityInfo == nil) {
                                Text("The service connection is lost, please check your internet connection or try again later")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .tag(Tab.currently)
                            } else {
                                Text("Internal error, please try again.")
                                    .multilineTextAlignment(.center)
                                    .tag(Tab.currently)
                            }
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    
                    if (locationManager.isFetchingCityInfo == false) {
                        if (locationManager.cityLocation != nil && locationManager.cityInfo != nil) {
                            
                            TodayView(cityInfo: locationManager.cityInfo)
                                .tabItem {
                                    VStack {
                                        Image(systemName: "calendar.day.timeline.left")
                                        Text("Today")
                                    }
                                }
                                .tag(Tab.today)
                            
                        } else {
                            if (locationManager.cityLocation == nil) {
                                Text("Geolocation is not available, please enable it in your App settings.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .tag(Tab.today)
                            } else if (locationManager.cityInfo == nil) {
                                Text("The service connection is lost, please check your internet connection or try again later")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .tag(Tab.today)
                            } else {
                                Text("Internal error, please try again.")
                                    .multilineTextAlignment(.center)
                                    .tag(Tab.today)
                            }
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    
                    if (locationManager.isFetchingCityInfo == false) {
                        if (locationManager.cityLocation != nil && locationManager.cityInfo != nil) {
                            
                            WeeklyView(cityInfo: locationManager.cityInfo)
                                .tabItem {
                                    VStack {
                                        Image(systemName: "calendar")
                                        Text("Weekly")
                                    }
                                }
                                .tag(Tab.weekly)
                            
                        } else {
                            if (locationManager.cityLocation == nil) {
                                Text("Geolocation is not available, please enable it in your App settings.")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .tag(Tab.weekly)
                                
                            } else if (locationManager.cityInfo == nil) {
                                Text("The service connection is lost, please check your internet connection or try again later")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .tag(Tab.weekly)
                            } else {
                                Text("Internal error, please try again.")
                                    .multilineTextAlignment(.center)
                                    .tag(Tab.weekly)
                            }
                        }
                    } else {
                        ProgressView()
                            .progressViewStyle(.circular)
                    }
                    
                    
                }
                .animation(nil, value: selectedTab)
                .searchable(text: $searchText)
                .tabViewStyle(.page(indexDisplayMode: .never))
                AppViewBar(selectedTab: $selectedTab)
//                LocationView()
            }
        }
        .preferredColorScheme(.dark)
        .padding(.bottom, 20)
        .background(getRealBackground(cityInfo: LocationManager.shared.cityInfo, weatherInfo: weatherInfo, showSearchBar: showSearchBar))
        .ignoresSafeArea(edges: searchBarNoAnimation ? [] : .bottom)
    }
}

#Preview {
    ContentView()
}
