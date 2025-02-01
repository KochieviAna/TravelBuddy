//
//  ArchivedJourneyDetailView.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI

struct ArchivedJourneyDetailView: View {
    var journey: ArchivedJourney
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Travel Buddy")
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading) {
                    Text(journey.journeyName)
                        .font(.title2)
                        .bold()
                    Text("Date: \(formattedDate(from: journey.date))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Text(journey.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
                
                // Archived Statistics
                VStack {
                    HStack {
                        Text("Distance:")
                        Spacer()
                        Text("\(String(format: "%.2f", journey.distanceKm)) KM")
                    }
                    if let fuelNeeded = journey.fuelNeeded {
                        HStack {
                            Text("Fuel Needed:")
                            Spacer()
                            Text("\(fuelNeeded) Gallons")
                        }
                    }
                    if let tankRefill = journey.tankRefill {
                        HStack {
                            Text("Tank Re-Fill:")
                            Spacer()
                            Text("\(tankRefill) Times")
                        }
                    }
                    if let co2Emissions = journey.co2Emissions {
                        HStack {
                            Text("CO2 Emissions:")
                            Spacer()
                            Text("\(co2Emissions) g/km")
                        }
                    }
                    if let electricConsumption = journey.electricConsumption {
                        HStack {
                            Text("Battery Needed:")
                            Spacer()
                            Text("\(electricConsumption) kWh")
                        }
                    }
                    if let chargingSessions = journey.chargingSessions {
                        HStack {
                            Text("Charging Sessions:")
                            Spacer()
                            Text("\(chargingSessions) Times")
                        }
                    }
                    if let hybridFuelNeeded = journey.hybridFuelNeeded {
                        HStack {
                            Text("Hybrid Fuel Needed:")
                            Spacer()
                            Text("\(hybridFuelNeeded) Gallons")
                        }
                    }
                    if let electricRangeUsed = journey.electricRangeUsed {
                        HStack {
                            Text("Electric Range Used:")
                            Spacer()
                            Text("\(electricRangeUsed) Miles")
                        }
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color(.systemBackground))
                        .shadow(radius: 2)
                )
            }
            .padding()
        }
        .navigationTitle("Archived Journey Details")
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
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
        electricRangeUsed: "40.0"
    ))
}
