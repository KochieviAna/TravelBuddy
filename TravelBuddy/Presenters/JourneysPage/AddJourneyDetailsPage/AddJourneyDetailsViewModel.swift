//
//  AddJourneyDetailsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 31.01.25.
//

import Foundation
import MapKit
import CoreLocation

class AddJourneyDetailsViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 46.603354, longitude: 1.888334),
                                               span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    init() {
        checkIfLocationServicesEnabled()
    }
    
    func checkIfLocationServicesEnabled() {
        LocationManager.shared.enableLocationServices()
        LocationManager.shared.$region.assign(to: &$region)
    }
}
