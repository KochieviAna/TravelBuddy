//
//  JourneyModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import Foundation
import FirebaseFirestore

struct Journey: Identifiable, Codable {
    @DocumentID var id: String?
    var journeyName: String
    var description: String
    var date: Date
    var distanceKm: Double
}
