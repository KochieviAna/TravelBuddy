//
//  CarModel.swift
//  TravelBuddy
//
//  Created by MacBook on 28.01.25.
//

import Foundation
import FirebaseFirestore

struct Car: Identifiable, Codable {
    @DocumentID var id: String?
    var brand: String
    var model: String
    var year: Int
    var engineType: String
    var fuelType: String
    var fuelTankCapacity: Double
    var combinedMpg: Double
    var fuelLitresPer100Km: Double
    var co2Emission: Double
    var batteryCapacityElectric: Double
    var epaKwh100MiElectric: Double
    var hybridEfficiency: Double
    var electricRange: Double
}
