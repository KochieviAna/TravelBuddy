//
//  LocationManager.swift
//  TravelBuddy
//
//  Created by MacBook on 30.01.25.
//

import Foundation
import CoreLocation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    let locationManager = CLLocationManager()
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.603354, longitude: 1.888334),
                                               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    private var permissionCompletion: ((Bool) -> Void)?
    
    override private init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        self.permissionCompletion = completion
        DispatchQueue.main.async { [weak self] in
            self?.locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func enableLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            requestLocationPermission { _ in }
        } else {
            DispatchQueue.main.async {
                print("⚠️ Location services are disabled. Show an alert.")
            }
        }
    }
    
    private func updateLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            break
        case .restricted, .denied:
            DispatchQueue.main.async {
                print("🚫 User denied or has restricted location access.")
            }
        case .authorizedAlways, .authorizedWhenInUse:
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else { return }
                self.startUpdatingLocation()
            }
        @unknown default:
            break
        }
    }
    
    private func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
        
        if let location = locationManager.location {
            DispatchQueue.main.async {
                self.region = MKCoordinateRegion(center: location.coordinate,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
            }
        }
        DispatchQueue.main.async {
            self.permissionCompletion?(true)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        updateLocationAuthorization()
    }
}
