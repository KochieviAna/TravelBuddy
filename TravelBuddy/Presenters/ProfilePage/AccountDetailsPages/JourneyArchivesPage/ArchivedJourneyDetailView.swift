//
//  ArchivedJourneyDetailView.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI

struct ArchivedJourneyDetailView: View {
    var journey: ArchivedJourney
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ReusableBackButtonWrapper {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 44, height: 44)
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text(journey.journeyName)
                        .font(.robotoSemiBold(size: 24))
                        .foregroundStyle(.deepBlue)
                    
                    Text("Date: \(formattedDate(from: journey.date))")
                        .font(.robotoRegular(size: 16))
                        .foregroundStyle(.stoneGrey)
                    
                    Text(journey.description.isEmpty ? "No Description Provided" : journey.description)
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
                
                if let vehicle = journey.vehicle {
                    archivedStatisticsView(for: journey, vehicle: vehicle)
                } else {
                    Text("No vehicle data available")
                        .font(.robotoSemiBold(size: 30))
                        .foregroundStyle(.stoneGrey)
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    
    private func archivedStatisticsView(for journey: ArchivedJourney, vehicle: Car) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Journey Statistics")
                .font(.robotoSemiBold(size: 30))
                .foregroundStyle(.deepBlue)
                .padding(.bottom, 5)
            
            statisticsRow(title: "Distance:", value: "\(String(format: "%.2f", journey.distanceKm)) KM")
            
            switch vehicle.engineType {
            case "Gasoline", "Diesel":
                showFuelStatistics(journey: journey)
            case "Electric":
                showElectricStatistics(journey: journey)
            case "Hybrid":
                showHybridStatistics(journey: journey)
            default:
                Text("No valid vehicle data available.")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: Color("primaryBlack").opacity(0.25), radius: 2, x: 2, y: 2)
        )
    }
    
    private func showFuelStatistics(journey: ArchivedJourney) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fuel Consumption")
                .font(.robotoSemiBold(size: 24))
                .foregroundStyle(.deepBlue)
            
            statisticsRow(title: "Fuel Needed:", value: journey.fuelNeeded ?? "N/A")
            statisticsRow(title: "Tank Re-Fill:", value: journey.tankRefill ?? "N/A")
            statisticsRow(title: "CO2 Emissions:", value: journey.co2Emissions ?? "N/A")
        }
    }
    
    private func showElectricStatistics(journey: ArchivedJourney) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Electric Consumption")
                .font(.robotoSemiBold(size: 24))
                .foregroundStyle(.deepBlue)
            
            statisticsRow(title: "Battery Needed:", value: journey.electricConsumption ?? "N/A")
            statisticsRow(title: "Charging Sessions:", value: journey.chargingSessions ?? "N/A")
        }
    }
    
    private func showHybridStatistics(journey: ArchivedJourney) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hybrid Consumption")
                .font(.robotoSemiBold(size: 24))
                .foregroundStyle(.deepBlue)
            
            statisticsRow(title: "Hybrid Fuel Needed:", value: journey.hybridFuelNeeded ?? "N/A")
            statisticsRow(title: "Electric Range Used:", value: journey.electricRangeUsed ?? "N/A")
            statisticsRow(title: "Charging Sessions:", value: journey.chargingSessions ?? "N/A")
        }
    }
    
    private func statisticsRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.robotoRegular(size: 16))
                .foregroundStyle(.stoneGrey)
            
            Spacer()
            
            Text(value)
                .font(.robotoRegular(size: 16))
                .foregroundStyle(.stoneGrey)
        }
    }
}

#Preview {
    ArchivedJourneyDetailView(journey: ArchivedJourney(
        journeyName: "Test Journey",
        description: "Sample description",
        date: Date(),
        distanceKm: 120.5,
        fuelNeeded: "5.2",
        tankRefill: "0.8",
        co2Emissions: "120.0",
        electricConsumption: "15.4",
        chargingSessions: "2",
        hybridFuelNeeded: "3.0",
        electricRangeUsed: "40.0",
        vehicle: Car(
            brand: "Toyota",
            model: "Prius",
            year: 2022,
            engineType: "Hybrid",
            fuelType: "Gasoline",
            fuelTankCapacity: 11.3,
            fuelConsumptionMpg: 52.0,
            co2Emission: 90.0,
            batteryCapacityElectric: 8.8,
            epaKwh100MiElectric: 25.0,
            hybridEfficiency: 50.0,
            electricRange: 25.0
        )
    ))
}
