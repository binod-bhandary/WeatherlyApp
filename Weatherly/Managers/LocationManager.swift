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
    
    // create new instance of CLLocationManagerDelegate
    let manager = CLLocationManager()
    
    // create location and loading state
    @Published var location: CLLocationCoordinate2D?//Stores the current geographical coordinate
    @Published var isLoading = false//Indicates whether location fetching is in progress
    
    
    override init() {
        super.init()
        manager.delegate = self//Sets the LocationManager as the delegate of CLLocationManager
    }
    //Requests the current location from the device's location servic
    func requestLocation() {
        isLoading = true//indicate the location request is in progress
        manager.requestLocation()//perform a one time location request
    }
    //Delegate method called when locations are updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate//Update the location with the first received coordinate
        isLoading = false //indicates that location fetching has completed
    }
    //Delegate method called when an error occurs while fetching the location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location", error)//print the error to the console
        isLoading = false//reset the loading state on error
    }
}
