//
//  ArchivedJourneyModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import Foundation
import FirebaseFirestore

struct ArchivedJourney: Identifiable, Codable {
    @DocumentID var id: String?
    var journeyName: String
    var description: String
    var date: Date
    var distanceKm: Double
    
    var fuelNeeded: String?
    var tankRefill: String?
    var co2Emissions: String?
    var electricConsumption: String?
    var chargingSessions: String?
    var hybridFuelNeeded: String?
    var electricRangeUsed: String?
    
    var vehicle: Car?
}
