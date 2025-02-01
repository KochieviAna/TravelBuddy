//
//  JourneysView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct JourneysView: View {
    @State private var journey: Journey? = nil
    @State private var vehicle: Car? = nil
    @State private var showAddJourneySheet = false
    @State private var showVehicleAlert = false
    @State private var comment: String = ""
    
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack {
            if let journey = journey, let vehicle = vehicle {
                journeyContentView(for: journey, vehicle: vehicle)
            } else {
                emptyView
            }
        }
        .ignoresSafeArea()
        .background(Color(.systemBackground))
        .padding(.top)
        .sheet(isPresented: $showAddJourneySheet) {
            AddJourneyDetailsView()
                .onDisappear {
                    fetchJourney()
                    fetchVehicle()
                }
        }
        .onAppear {
            fetchJourney()
            fetchVehicle()
        }
    }
    
    // MARK: - Fetch Journey Data
    private func fetchJourney() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("journeys")
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching journey: \(error)")
                } else if let document = snapshot?.documents.first {
                    do {
                        self.journey = try document.data(as: Journey.self)
                    } catch {
                        print("Error decoding journey: \(error)")
                    }
                }
            }
    }
    
    // MARK: - Fetch Vehicle Data
    private func fetchVehicle() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("vehicles")
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching vehicle: \(error)")
                } else if let document = snapshot?.documents.first {
                    do {
                        self.vehicle = try document.data(as: Car.self)
                    } catch {
                        print("Error decoding vehicle: \(error)")
                    }
                } else {
                    self.vehicle = nil
                }
            }
    }
    
    // MARK: - Empty View (Centered)
    private var emptyView: some View {
        VStack {
            Spacer()
            
            Image("journey")
                .resizable()
                .frame(width: 200, height: 200)
                .opacity(0.5)
            
            Button("Start Journey with Travel Buddy") {
                if vehicle == nil {
                    showVehicleAlert = true
                } else {
                    showAddJourneySheet.toggle()
                }
            }
            .foregroundStyle(.deepBlue)
            .font(.robotoBold(size: 16))
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Journey View with Fixed Bottom Button
    private func journeyContentView(for journey: Journey, vehicle: Car) -> some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Travel Buddy")
                        .font(.robotoSemiBold(size: 30))
                        .foregroundStyle(.deepBlue)
                    
                    VStack(alignment: .leading) {
                        Text(journey.journeyName)
                            .font(.robotoSemiBold(size: 24))
                            .foregroundStyle(.deepBlue)
                        Text("Date: \(formattedDate(from: journey.date))")
                            .font(.robotoRegular(size: 16))
                            .foregroundStyle(.stoneGrey)
                        
                        Text(journey.description)
                            .font(.robotoRegular(size: 16))
                            .foregroundStyle(.stoneGrey)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color("primaryBlack").opacity(0.25), radius: 2, x: 2, y: 2)
                    )
                    
                    VStack(alignment: .leading) {
                        journeyStatistics(for: journey, vehicle: vehicle)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: Color("primaryBlack").opacity(0.25), radius: 2, x: 2, y: 2)
                    )
                    
                    Spacer()
                    
                    ReusableButtonWrapper(title: "End Journey", action: endJourneyAction)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func journeyStatistics(for journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Distance")
                Spacer()
                Text("\(String(format: "%.2f", journey.distanceKm)) KM")
            }
            
            if vehicle.engineType == "Gasoline" || vehicle.engineType == "Diesel" {
                fuelStatistics(journey: journey, vehicle: vehicle)
            }
            
            if vehicle.engineType == "Electric" {
                electricStatistics(journey: journey, vehicle: vehicle)
            }
            
            if vehicle.engineType == "Hybrid" {
                hybridStatistics(journey: journey, vehicle: vehicle)
            }
        }
    }
    
    private func fuelStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Gallons Needed")
                Spacer()
                Text("\(calculateFuelNeeded(distance: journey.distanceKm, vehicle: vehicle)) Gallons")
            }
            HStack {
                Text("Tank Re-Fill")
                Spacer()
                Text("\(calculateTankRefill(distance: journey.distanceKm, vehicle: vehicle)) Times")
            }
            HStack {
                Text("CO2 Emissions")
                Spacer()
                Text("\(calculateCO2Emissions(distance: journey.distanceKm, vehicle: vehicle)) g/km")
            }
        }
    }
    
    private func electricStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Battery Needed")
                Spacer()
                Text("\(calculateElectricConsumption(distance: journey.distanceKm, vehicle: vehicle)) kWh")
            }
            HStack {
                Text("Charging Sessions")
                Spacer()
                Text("\(calculateChargingSessions(distance: journey.distanceKm, vehicle: vehicle)) Times")
            }
        }
    }
    
    private func hybridStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Gallons Needed")
                Spacer()
                Text("\(calculateHybridFuelNeeded(distance: journey.distanceKm, vehicle: vehicle)) Gallons")
            }
            HStack {
                Text("Tank Re-Fill")
                Spacer()
                Text("\(calculateTankRefill(distance: journey.distanceKm, vehicle: vehicle)) Times")
            }
            HStack {
                Text("Electric Range Used")
                Spacer()
                Text("\(calculateElectricRangeUsed(distance: journey.distanceKm, vehicle: vehicle)) Miles")
            }
            HStack {
                Text("Charging Sessions")
                Spacer()
                Text("\(calculateChargingSessions(distance: journey.distanceKm, vehicle: vehicle)) Times")
            }
            HStack {
                Text("CO2 Emissions")
                Spacer()
                Text("\(calculateCO2Emissions(distance: journey.distanceKm, vehicle: vehicle)) g/km")
            }
        }
    }
    
    private func calculateCO2Emissions(distance: Double, vehicle: Car) -> String {
        guard vehicle.co2Emission > 0 else { return "N/A" }
        return String(format: "%.1f", (distance / 1.60934) * vehicle.co2Emission)
    }
    
    
    private func calculateFuelNeeded(distance: Double, vehicle: Car) -> String {
        guard vehicle.fuelConsumptionMpg > 0 else { return "N/A" }
        return String(format: "%.2f", distance / (vehicle.fuelConsumptionMpg * 1.60934))
    }
    
    private func calculateTankRefill(distance: Double, vehicle: Car) -> String {
        guard vehicle.fuelTankCapacity > 0, vehicle.fuelConsumptionMpg > 0 else { return "N/A" }
        let fuelNeeded = distance / (vehicle.fuelConsumptionMpg * 1.60934)
        return String(format: "%.1f", fuelNeeded / vehicle.fuelTankCapacity)
    }
    
    private func calculateElectricConsumption(distance: Double, vehicle: Car) -> String {
        guard vehicle.epaKwh100MiElectric > 0 else { return "N/A" }
        let miles = distance / 1.60934
        return String(format: "%.2f", (miles / 100) * vehicle.epaKwh100MiElectric)
    }
    
    private func calculateChargingSessions(distance: Double, vehicle: Car) -> String {
        guard vehicle.batteryCapacityElectric > 0 else { return "N/A" }
        let totalBatteryNeeded = Double(calculateElectricConsumption(distance: distance, vehicle: vehicle)) ?? 0.0
        return String(format: "%.1f", totalBatteryNeeded / vehicle.batteryCapacityElectric)
    }
    
    private func calculateHybridFuelNeeded(distance: Double, vehicle: Car) -> String {
        guard vehicle.hybridEfficiency > 0 else { return "N/A" }
        let miles = distance / 1.60934
        return String(format: "%.2f", miles / vehicle.hybridEfficiency)
    }
    
    private func calculateElectricRangeUsed(distance: Double, vehicle: Car) -> String {
        guard vehicle.electricRange > 0 else { return "N/A" }
        return String(format: "%.1f", min(distance / 1.60934, vehicle.electricRange))
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func endJourneyAction() {
        guard let userId = Auth.auth().currentUser?.uid, let journey = journey, let vehicle = vehicle else { return }
        
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
            electricRangeUsed: calculateElectricRangeUsed(distance: journey.distanceKm, vehicle: vehicle)
        )

        let db = Firestore.firestore()
        
        // Save Archived Journey Separately
        do {
            let archivedData = try Firestore.Encoder().encode(archivedJourney)
            db.collection("users").document(userId).collection("archivedJourneys").addDocument(data: archivedData) { error in
                if let error = error {
                    print("Error archiving journey: \(error)")
                } else {
                    // Remove from Active Journeys
                    db.collection("users").document(userId).collection("journeys").document(journey.id ?? "").delete { error in
                        if let error = error {
                            print("Error deleting journey: \(error)")
                        } else {
                            DispatchQueue.main.async {
                                self.journey = nil // Remove from View
                            }
                        }
                    }
                }
            }
        } catch {
            print("Error encoding archived journey: \(error)")
        }
    }
}

#Preview {
    JourneysView()
}
