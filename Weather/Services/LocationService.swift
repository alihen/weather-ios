//
//  LocationService.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject {

    private let locationManager = CLLocationManager()

    var delegate: CLLocationManagerDelegate? {
        get {
            return locationManager.delegate
        }
        set(newValue) {
            locationManager.delegate = newValue
        }
    }

    override init() {
        super.init()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    func startUpdatingLocation() {
        self.locationManager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        self.locationManager.stopUpdatingLocation()
    }

    func getPlaceForCurrentLocation(completion: @escaping (CLPlacemark?) -> Void) {
        guard let location = self.locationManager.location else {
            completion(nil)
            return
        }

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in

            guard error == nil else {
                debugPrint("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }

            guard let placemark = placemarks?[0] else {
                debugPrint("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }

            completion(placemark)
        }
    }
}
