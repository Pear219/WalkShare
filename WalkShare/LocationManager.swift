//
//  LocationManager.swift
//  WalkShare
//
//  Created by Kokona Kato on 2024/06/10.
//

import Foundation
import CoreLocation
import Combine
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var address: String = "取得中..."

    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            print("Location updated: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            fetchAddress(from: location)
        } else {
            print("No locations found")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
        address = "位置情報の取得に失敗しました: \(error.localizedDescription)"
    }

    private func fetchAddress(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Failed to reverse geocode location: \(error.localizedDescription)")
                self.address = "住所が取得できませんでした: \(error.localizedDescription)"
                return
            }

            if let placemark = placemarks?.first {
                self.address = [
                    placemark.thoroughfare,
                    placemark.locality,
                    placemark.administrativeArea,
                    placemark.postalCode
                ].compactMap { $0 }.joined(separator: ", ")
                print("Address found: \(self.address)")
            } else {
                print("No placemarks found")
                self.address = "住所が取得できませんでした"
            }
        }
    }
}





