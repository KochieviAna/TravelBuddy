//
//  StatisticsView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI
import Charts
import FirebaseFirestore
import FirebaseAuth

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Journey Statistics")
                    .font(.robotoSemiBold(size: 24))
                    .foregroundStyle(.deepBlue)
                
                if viewModel.archivedJourneys.isEmpty {
                    Text("No journeys available")
                        .font(.robotoRegular(size: 16))
                        .foregroundStyle(.stoneGrey)
                } else {
                    if viewModel.hasDistanceData { totalDistanceChart }
                    if viewModel.hasFuelData { fuelConsumptionChart }
                    if viewModel.hasCO2Data { co2EmissionsChart }
                    if viewModel.hasElectricData { electricConsumptionChart }
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.fetchArchivedJourneys()
        }
    }
    
    private var fuelConsumptionChart: some View {
        VStack {
            Text("Fuel Consumption Over Time")
                .font(.robotoSemiBold(size: 18))
                .foregroundStyle(.deepBlue)
            
            Chart {
                ForEach(viewModel.archivedJourneys, id: \.id) { journey in
                    if let fuelNeeded = Double(journey.fuelNeeded ?? "0") {
                        LineMark(
                            x: .value("Date", journey.date),
                            y: .value("Fuel Needed (Liters)", fuelNeeded)
                        )
                        .foregroundStyle(.red)
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(viewModel.dateFormatter.string(from: date))
                    }
                }
            }
        }
    }
    
    private var co2EmissionsChart: some View {
        VStack {
            Text("CO2 Emissions Over Time")
                .font(.robotoSemiBold(size: 18))
                .foregroundStyle(.deepBlue)
            
            Chart {
                ForEach(viewModel.archivedJourneys, id: \.id) { journey in
                    if let co2Emissions = Double(journey.co2Emissions ?? "0") {
                        LineMark(
                            x: .value("Date", journey.date),
                            y: .value("CO2 Emissions (g/km)", co2Emissions)
                        )
                        .foregroundStyle(.purple)
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(viewModel.dateFormatter.string(from: date))
                    }
                }
            }
        }
    }
    
    private var electricConsumptionChart: some View {
        VStack {
            Text("Electric Consumption Trends")
                .font(.robotoSemiBold(size: 18))
                .foregroundStyle(.deepBlue)
            
            Chart {
                ForEach(viewModel.archivedJourneys, id: \.id) { journey in
                    if let electricConsumption = Double(journey.electricConsumption ?? "0") {
                        LineMark(
                            x: .value("Date", journey.date),
                            y: .value("Electric Consumption (kWh)", electricConsumption)
                        )
                        .foregroundStyle(.blue)
                        .interpolationMethod(.catmullRom)
                    }
                }
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(viewModel.dateFormatter.string(from: date))
                    }
                }
            }
        }
    }
    
    private var totalDistanceChart: some View {
        VStack {
            Text("Total Distance Traveled Over Time")
                .font(.robotoSemiBold(size: 18))
                .foregroundStyle(.deepBlue)
            
            Chart {
                ForEach(viewModel.archivedJourneys, id: \.id) { journey in
                    LineMark(
                        x: .value("Date", journey.date),
                        y: .value("Distance (KM)", journey.distanceKm)
                    )
                    .foregroundStyle(.green)
                    .interpolationMethod(.catmullRom)
                }
            }
            .frame(height: 250)
            .chartXAxis {
                AxisMarks { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel(viewModel.dateFormatter.string(from: date))
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
}
