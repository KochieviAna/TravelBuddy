//
//  JourneysView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestore

struct JourneysView: View {
    @State private var journey: Journey? = nil
    @State private var vehicle: Car? = nil
    @State private var showAddJourneySheet = false
    @State private var comment: String = ""
    
    private let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            if let journey = journey, let vehicle = vehicle {
                journeyView(for: journey, vehicle: vehicle)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            } else {
                emptyView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
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
                }
            }
    }
    
    private var emptyView: some View {
        VStack {
            Image("journey")
                .resizable()
                .frame(width: 200, height: 200)
                .opacity(0.5)
            
            Button("Start Journey with Travel Buddy") {
                showAddJourneySheet.toggle()
            }
            .foregroundStyle(.deepBlue)
            .font(.robotoBold(size: 16))
            .padding()
        }
    }
    
    private func journeyView(for journey: Journey, vehicle: Car) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Your Journey")
                .font(.robotoSemiBold(size: 30))
                .foregroundStyle(.deepBlue)
            
            Text(journey.journeyName)
                .font(.robotoBold(size: 24))
                .foregroundStyle(.deepBlue)
            
            Text(journey.description)
                .font(.robotoRegular(size: 16))
                .foregroundStyle(.stoneGrey)
            
            Text("Date: \(formattedDate(from: journey.date))")
                .font(.robotoRegular(size: 16))
                .foregroundStyle(.deepBlue)
            
            Divider()
            
            VStack {
                journeyStatistics(for: journey, vehicle: vehicle)
            }
            
            Spacer()
            
            commentSection()
        }
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
    
    private func commentSection() -> some View {
        VStack {
            TextField("Leave a comment...", text: $comment)
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.stoneGrey, lineWidth: 1)
                )
            
            HStack {
                Spacer()
                Button(action: {
                    print("Comment Sent: \(comment)")
                }) {
                    Image(systemName: "paperplane.circle.fill")
                        .foregroundColor(.deepBlue)
                        .font(.system(size: 28))
                }
            }
            .padding(.top, 8)
        }
    }
}

#Preview {
    JourneysView()
}
