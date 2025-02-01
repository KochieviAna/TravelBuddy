//
//  JourneysViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class JourneysViewModel: ObservableObject {
    @Published var journey: Journey? = nil
    @Published var vehicle: Car? = nil
    @Published var showAddJourneySheet = false
    @Published var showVehicleAlert = false
    
    private let db = Firestore.firestore()
    
    init() {
        fetchJourney()
        fetchVehicle()
    }
    
    func fetchJourney() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("journeys")
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching journey: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else { return }
                
                do {
                    let fetchedJourney = try document.data(as: Journey.self)
                    DispatchQueue.main.async {
                        self.journey = fetchedJourney
                    }
                } catch {
                    print("❌ Error decoding journey: \(error)")
                }
            }
    }
    
    func fetchVehicle() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("vehicles")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching vehicle: \(error)")
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    DispatchQueue.main.async {
                        self.vehicle = nil
                    }
                    return
                }
                
                do {
                    let fetchedVehicle = try document.data(as: Car.self)
                    DispatchQueue.main.async {
                        self.vehicle = fetchedVehicle
                    }
                } catch {
                    print("❌ Error decoding vehicle: \(error)")
                }
            }
    }
    
    func endJourney() {
        guard let userId = Auth.auth().currentUser?.uid,
              let journey = journey,
              let vehicle = vehicle else { return }
        
        let archivedJourney = ArchivedJourney(
            journeyName: journey.journeyName,
            description: journey.description,
            date: journey.date,
            distanceKm: journey.distanceKm,
            fuelNeeded: calculateFuelNeeded(distance: journey.distanceKm, vehicle: vehicle),
            tankRefill: calculateTankRefill(distance: journey.distanceKm, vehicle: vehicle),
            co2Emissions: calculateCO2Emissions(distance: journey.distanceKm, vehicle: vehicle),
            electricConsumption: calculateElectricConsumption(distance: journey.distanceKm, vehicle: vehicle),
            chargingSessions: calculateChargingSessions(distance: journey.distanceKm, vehicle: vehicle),
            hybridFuelNeeded: calculateHybridFuelNeeded(distance: journey.distanceKm, vehicle: vehicle),
            electricRangeUsed: calculateElectricRangeUsed(distance: journey.distanceKm, vehicle: vehicle),
            vehicle: vehicle
        )
        
        do {
            let archivedData = try Firestore.Encoder().encode(archivedJourney)
            
            db.collection("users").document(userId).collection("archivedJourneys")
                .addDocument(data: archivedData) { error in
                    if let error = error {
                        print("❌ Error archiving journey: \(error)")
                        return
                    }
                    
                    self.db.collection("users").document(userId).collection("journeys")
                        .document(journey.id ?? "").delete { error in
                            if let error = error {
                                print("❌ Error deleting journey: \(error)")
                            } else {
                                DispatchQueue.main.async {
                                    self.journey = nil
                                }
                            }
                        }
                }
            
        } catch {
            print("❌ Error encoding archived journey: \(error)")
        }
    }
    
    func calculateFuelNeeded(distance: Double, vehicle: Car) -> String {
        guard vehicle.fuelConsumptionMpg > 0 else { return "N/A" }
        return String(format: "%.2f", distance / (vehicle.fuelConsumptionMpg * 1.60934))
    }
    
    func calculateTankRefill(distance: Double, vehicle: Car) -> String {
        guard vehicle.fuelTankCapacity > 0, vehicle.fuelConsumptionMpg > 0 else { return "N/A" }
        let fuelNeeded = distance / (vehicle.fuelConsumptionMpg * 1.60934)
        return String(format: "%.1f", fuelNeeded / vehicle.fuelTankCapacity)
    }
    
    func calculateCO2Emissions(distance: Double, vehicle: Car) -> String {
        guard vehicle.co2Emission > 0 else { return "N/A" }
        return String(format: "%.1f", (distance / 1.60934) * vehicle.co2Emission)
    }
    
    func calculateElectricConsumption(distance: Double, vehicle: Car) -> String {
        guard vehicle.epaKwh100MiElectric > 0 else { return "N/A" }
        let miles = distance / 1.60934
        return String(format: "%.2f", (miles / 100) * vehicle.epaKwh100MiElectric)
    }
    
    func calculateChargingSessions(distance: Double, vehicle: Car) -> String {
        guard vehicle.batteryCapacityElectric > 0 else { return "N/A" }
        let totalBatteryNeeded = Double(calculateElectricConsumption(distance: distance, vehicle: vehicle)) ?? 0.0
        return String(format: "%.1f", totalBatteryNeeded / vehicle.batteryCapacityElectric)
    }
    
    func calculateHybridFuelNeeded(distance: Double, vehicle: Car) -> String {
        guard vehicle.hybridEfficiency > 0 else { return "N/A" }
        let miles = distance / 1.60934
        return String(format: "%.2f", miles / vehicle.hybridEfficiency)
    }
    
    func calculateElectricRangeUsed(distance: Double, vehicle: Car) -> String {
        guard vehicle.electricRange > 0 else { return "N/A" }
        return String(format: "%.1f", min(distance / 1.60934, vehicle.electricRange))
    }
}
