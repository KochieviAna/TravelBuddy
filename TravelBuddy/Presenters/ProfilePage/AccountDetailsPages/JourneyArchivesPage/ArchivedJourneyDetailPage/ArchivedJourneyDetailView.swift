//
//  ArchivedJourneyDetailView.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI

struct ArchivedJourneyDetailView: View {
    @StateObject private var viewModel: ArchivedJourneyDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(journey: ArchivedJourney) {
        _viewModel = StateObject(wrappedValue: ArchivedJourneyDetailViewModel(journey: journey))
    }
    
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
                    Text(viewModel.journey.journeyName)
                        .font(.robotoSemiBold(size: 24))
                        .foregroundStyle(.deepBlue)
                    
                    Text("Date: \(viewModel.formattedDate())")
                        .font(.robotoRegular(size: 16))
                        .foregroundStyle(.stoneGrey)
                    
                    Text(viewModel.journey.description.isEmpty ? "No Description Provided" : viewModel.journey.description)
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
                
                if viewModel.vehicle != nil {
                    archivedStatisticsView()
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
    
    private func archivedStatisticsView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Journey Statistics")
                .font(.robotoSemiBold(size: 30))
                .foregroundStyle(.deepBlue)
                .padding(.bottom, 5)
            
            ForEach(viewModel.statisticsRows()) { stat in
                statisticsRow(title: stat.title, value: stat.value)
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
