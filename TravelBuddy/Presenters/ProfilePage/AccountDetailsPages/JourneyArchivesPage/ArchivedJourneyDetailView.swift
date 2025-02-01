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
                .padding(.leading)

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
            }
            .padding()
        }
        .navigationBarHidden(true) // Fully hide the navigation bar
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
