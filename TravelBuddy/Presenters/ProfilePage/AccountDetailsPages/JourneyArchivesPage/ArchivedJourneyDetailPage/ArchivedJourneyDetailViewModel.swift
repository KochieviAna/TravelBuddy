//
//  ArchivedJourneyDetailViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI

class ArchivedJourneyDetailViewModel: ObservableObject {
    @Published var journey: ArchivedJourney
    @Published var vehicle: Car?
    
    init(journey: ArchivedJourney) {
        self.journey = journey
        self.vehicle = journey.vehicle
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: journey.date)
    }
    
    func statisticsRows() -> [StatisticItem] {
        var stats: [StatisticItem] = []
        
        stats.append(StatisticItem(title: "Distance:", value: "\(String(format: "%.2f", journey.distanceKm)) KM"))
        
        guard let vehicle = vehicle else { return stats }
        
        switch vehicle.engineType {
        case "Gasoline", "Diesel":
            stats.append(contentsOf: [
                StatisticItem(title: "Fuel Needed:", value: journey.fuelNeeded ?? "N/A"),
                StatisticItem(title: "Tank Re-Fill:", value: journey.tankRefill ?? "N/A"),
                StatisticItem(title: "CO2 Emissions:", value: journey.co2Emissions ?? "N/A")
            ])
            
        case "Electric":
            stats.append(contentsOf: [
                StatisticItem(title: "Battery Needed:", value: journey.electricConsumption ?? "N/A"),
                StatisticItem(title: "Charging Sessions:", value: journey.chargingSessions ?? "N/A")
            ])
            
        case "Hybrid":
            stats.append(contentsOf: [
                StatisticItem(title: "Hybrid Fuel Needed:", value: journey.hybridFuelNeeded ?? "N/A"),
                StatisticItem(title: "Electric Range Used:", value: journey.electricRangeUsed ?? "N/A"),
                StatisticItem(title: "Charging Sessions:", value: journey.chargingSessions ?? "N/A")
            ])
            
        default:
            break
        }
        
        return stats
    }
}

struct StatisticItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
}
