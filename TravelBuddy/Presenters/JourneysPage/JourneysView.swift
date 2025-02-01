//
//  JourneysView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct JourneysView: View {
    @StateObject private var viewModel = JourneysViewModel()
    
    var body: some View {
        VStack {
            if let journey = viewModel.journey, let vehicle = viewModel.vehicle {
                journeyContentView(for: journey, vehicle: vehicle)
            } else {
                emptyView
            }
        }
        .ignoresSafeArea()
        .background(Color(.systemBackground))
        .padding(.top)
        .sheet(isPresented: $viewModel.showAddJourneySheet) {
            AddJourneyDetailsView()
                .onDisappear {
                    viewModel.fetchJourney()
                    viewModel.fetchVehicle()
                }
        }
    }
    
    private var emptyView: some View {
        VStack {
            Spacer()
            
            Image("journey")
                .resizable()
                .frame(width: 200, height: 200)
                .opacity(0.5)
            
            Button("Start Journey with Travel Buddy") {
                if viewModel.vehicle == nil {
                    viewModel.showVehicleAlert = true
                } else {
                    viewModel.showAddJourneySheet.toggle()
                }
            }
            .foregroundStyle(.deepBlue)
            .font(.robotoBold(size: 16))
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func journeyContentView(for journey: Journey, vehicle: Car) -> some View {
        VStack(alignment: .leading) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Travel Buddy")
                        .font(.robotoSemiBold(size: 30))
                        .foregroundStyle(.deepBlue)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text(journey.journeyName)
                                .font(.robotoSemiBold(size: 24))
                                .foregroundStyle(.deepBlue)
                            Spacer()
                        }
                        
                        HStack {
                            Text("Date: \(formattedDate(from: journey.date))")
                                .font(.robotoRegular(size: 16))
                                .foregroundStyle(.stoneGrey)
                            Spacer()
                        }
                        
                        HStack {
                            Text(journey.description)
                                .font(.robotoRegular(size: 16))
                                .foregroundStyle(.stoneGrey)
                            Spacer()
                        }
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
                    
                    ReusableButtonWrapper(title: "End Journey", action: viewModel.endJourney)
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
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text("\(String(format: "%.2f", journey.distanceKm)) KM")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            
            switch vehicle.engineType {
            case "Gasoline", "Diesel":
                fuelStatistics(journey: journey, vehicle: vehicle)
            case "Electric":
                electricStatistics(journey: journey, vehicle: vehicle)
            case "Hybrid":
                hybridStatistics(journey: journey, vehicle: vehicle)
            default:
                Text("No valid vehicle data available.")
            }
        }
    }
    
    private func fuelStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Gallons Needed")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateFuelNeeded(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            HStack {
                Text("Tank Re-Fill")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateTankRefill(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            HStack {
                Text("CO2 Emissions")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateCO2Emissions(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
        }
    }
    
    private func electricStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Battery Needed")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateElectricConsumption(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            HStack {
                Text("Charging Sessions")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateChargingSessions(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
        }
    }
    
    private func hybridStatistics(journey: Journey, vehicle: Car) -> some View {
        VStack {
            HStack {
                Text("Hybrid Fuel Needed")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateHybridFuelNeeded(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            HStack {
                Text("Electric Range Used")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateElectricRangeUsed(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
            HStack {
                Text("Charging Sessions")
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
                
                Spacer()
                
                Text(viewModel.calculateChargingSessions(distance: journey.distanceKm, vehicle: vehicle))
                    .font(.robotoRegular(size: 16))
                    .foregroundStyle(.stoneGrey)
            }
        }
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    JourneysView()
}
