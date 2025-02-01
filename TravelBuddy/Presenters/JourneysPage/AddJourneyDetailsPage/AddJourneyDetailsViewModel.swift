//
//  AddJourneyDetailsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 31.01.25.
//

import Foundation
import MapKit
import CoreLocation

struct PinnedLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

class AddJourneyDetailsViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.603354, longitude: 1.888334),
                                               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    @Published var pinnedLocations: [PinnedLocation] = []
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var distanceToPin: Double?
    
    private var locationManager = LocationManager.shared
    
    init() {
        checkIfLocationServicesEnabled()
    }
    
    func checkIfLocationServicesEnabled() {
        locationManager.enableLocationServices()
        locationManager.$region.assign(to: &$region)
        
        if let userLoc = locationManager.locationManager.location?.coordinate {
            self.userLocation = userLoc
        }
    }
    
    func pinLocation(at coordinate: CLLocationCoordinate2D) {
        let newPin = PinnedLocation(coordinate: coordinate)
        pinnedLocations = [newPin]
        calculateDistance()
    }
    
    func calculateDistance() {
        guard let userLoc = userLocation, let pinnedLoc = pinnedLocations.first?.coordinate else {
            distanceToPin = nil
            return
        }
        
        let userLocation = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)
        let pinnedLocation = CLLocation(latitude: pinnedLoc.latitude, longitude: pinnedLoc.longitude)
        
        distanceToPin = userLocation.distance(from: pinnedLocation) / 1000
    }
}
