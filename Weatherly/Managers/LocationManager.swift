//
//  LocationManager.swift
//  Weatherly
//
//  Created by iMac on 29/4/2024.
//

import Foundation
import CoreLocation


// create the class conform to protocol
// NSObject, ObserveableObject, ClLocationManagerDelegate
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cityLocation: City?
    @Published var cityInfo: CityInfo?
    
    @Published var isFetchingCityList = false
    
    @Published var isFetchingCityInfo = false
    
    private var userLocStatus: CLAuthorizationStatus?
    
    static let shared = LocationManager()
    
    // create new instance of CLLocationManagerDelegate
    private var locationManager = CLLocationManager()
//    let manager = CLLocationManager()
    
    // create location and loading state
    @Published var location: CLLocationCoordinate2D?//Stores the current geographical coordinate
    @Published var isLoading = false//Indicates whether location fetching is in progress
    
    
    override init() {
        super.init()
        locationManager.delegate = self //Sets the LocationManager as the delegate of CLLocationManager
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        // test
        isLoading = true//indicate the location request is in progress
        locationManager.requestLocation()//perform a one time location request
        
        if (userLocStatus != nil) {
            if (userLocStatus == .authorizedWhenInUse || userLocStatus == .authorizedAlways) {
                locationManager.startUpdatingLocation()
            } else {
                cityLocation = nil
                cityInfo = nil
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        DispatchQueue.main.async {
            self.isFetchingCityInfo = true
        }
        location = locations.first?.coordinate//Update the location with the first received coordinate
        isLoading = false //indicates that location fetching has completed
//        print("STARTING FILL USER LOCATION !")
        guard let latestLocation = locations.first else { return }
        locationManager.stopUpdatingLocation()
        
        
        self.cityLocation = City(id: 1, name: "", latitude: latestLocation.coordinate.latitude, longitude: latestLocation.coordinate.longitude)
        
        Task {
            getPlace(for: latestLocation) { placemark in
                guard let placemark = placemark else { return }
                if let cityName = placemark.locality {
                    self.cityLocation?.name = cityName
                }
                
                if let country = placemark.country {
                    self.cityLocation?.country = country
                }
                
                if let state = placemark.administrativeArea {
                    self.cityLocation?.admin1 = state
                }
                
                if let cityTimezone = placemark.timeZone {
                    self.cityLocation?.timezone = cityTimezone.identifier
                }
                
                Task {
                    let fetchedCityInfo = await fetchCityInfo(city: self.cityLocation!)
                    DispatchQueue.main.async {
                        self.cityInfo = fetchedCityInfo
                        self.isFetchingCityInfo = false

                    }
                }
            }
        }
        print("ENDING FILL USER LOCATION !")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        userLocStatus = status
        switch status {
        case .notDetermined:
            print("DEBUG : Not determined")
        case .restricted:
            print("DEBUG : Restricted")
        case .denied:
            print("DEBUG : Denied")
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            print("DEBUG : Auth always")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            print("DEBUG : Auth when in use")
        case .authorized:
            locationManager.startUpdatingLocation()
            print("DEBUG : One time")
        @unknown default:
            break
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error of location : \(error.localizedDescription)")
        isLoading = false//reset the loading state on error
    }
    

    
    func updateCity(city: City) async {
        DispatchQueue.main.async {
            self.cityLocation = city
        }
        if (cityLocation != nil) {
            let cityInfoFetching = await fetchCityInfo(city: cityLocation!)
            DispatchQueue.main.async {
                self.cityInfo = cityInfoFetching
            }
            
        } else {
            print("Invalid City")
        }
        
    }
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    
}
