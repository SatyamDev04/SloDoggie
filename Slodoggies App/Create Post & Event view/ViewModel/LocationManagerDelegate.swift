//
//  LocationManagerDelegate.swift
//  Slodoggies App
//
//  Created by YATIN  KALRA on 18/11/25.
//


import CoreLocation

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let manager = CLLocationManager()
    var onAddressFetched: ((String, CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestLocation() {
        let status = manager.authorizationStatus
        
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            print("Location permission denied")
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Permission Denied")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        default: break
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location failed:", error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let coord = location.coordinate
        fetchAddress(from: coord)
    }

    private func fetchAddress(from coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)) { placemarks, error in
            if let place = placemarks?.first {
                let address = [
                    place.name,
                    place.subLocality,
                    place.locality,
                    place.administrativeArea,
                    place.postalCode
                ]
                .compactMap { $0 }
                .joined(separator: ", ")

                self.onAddressFetched?(address, coordinate)
            }
        }
    }
}
