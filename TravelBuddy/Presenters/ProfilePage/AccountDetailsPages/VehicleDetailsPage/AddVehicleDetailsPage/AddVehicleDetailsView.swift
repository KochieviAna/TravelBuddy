//
//  AddVehicleDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 28.01.25.
//

import SwiftUI

struct AddVehicleDetailsView: View {
    
    var onAddCar: (Car) -> Void
    
    @State private var brand = ""
    @State private var model = ""
    @State private var year = ""
    @State private var engineType = "Gasoline"
    @State private var fuelType = ""
    @State private var fuelTankCapacity = ""
    @State private var combinedMpg = ""
    @State private var fuelLitresPer100Km = ""
    @State private var co2Emission = ""
    @State private var batteryCapacityElectric = ""
    @State private var epaKwh100MiElectric = ""
    @State private var hybridEfficiency = ""
    @State private var electricRange = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("General Information")) {
                    TextField("Brand", text: $brand)
                    TextField("Model", text: $model)
                    TextField("Year", text: $year)
                    
                    Picker("Engine Type", selection: $engineType) {
                        Text("Gasoline").tag("Gasoline")
                        Text("Electric").tag("Electric")
                        Text("Hybrid").tag("Hybrid")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Fuel Type", text: $fuelType)
                }
                
                if engineType == "Gasoline" {
                    Section(header: Text("Gasoline Vehicle Information")) {
                        TextField("Fuel Tank Capacity", text: $fuelTankCapacity)
                        TextField("Combined MPG", text: $combinedMpg)
                        TextField("Fuel Consumption (L/100km)", text: $fuelLitresPer100Km)
                        TextField("CO2 Emissions (g/km)", text: $co2Emission)
                    }
                }
                
                if engineType == "Electric" {
                    Section(header: Text("Electric Vehicle Information")) {
                        TextField("Battery Capacity (kWh)", text: $batteryCapacityElectric)
                        TextField("EPA Electric Consumption (kWh/100mi)", text: $epaKwh100MiElectric)
                    }
                }
                
                if engineType == "Hybrid" {
                    Section(header: Text("Hybrid Vehicle Information")) {
                        TextField("CO2 Emissions (g/km)", text: $co2Emission)
                        TextField("Hybrid Fuel Efficiency (MPG)", text: $hybridEfficiency)
                        TextField("Electric Range (miles)", text: $electricRange)
                    }
                }
                
                Button("Save Vehicle") {
                    let car = Car(
                        brand: brand,
                        model: model,
                        year: Int(year) ?? 0,
                        engineType: engineType,
                        fuelType: fuelType,
                        fuelTankCapacity: Double(fuelTankCapacity) ?? 0,
                        combinedMpg: Double(combinedMpg) ?? 0,
                        fuelLitresPer100Km: Double(fuelLitresPer100Km) ?? 0,
                        co2Emission: Double(co2Emission) ?? 0,
                        batteryCapacityElectric: Double(batteryCapacityElectric) ?? 0,
                        epaKwh100MiElectric: Double(epaKwh100MiElectric) ?? 0,
                        hybridEfficiency: Double(hybridEfficiency) ?? 0,
                        electricRange: Double(electricRange) ?? 0
                    )
                    onAddCar(car)
                }
            }
            .navigationBarTitle("Add Vehicle", displayMode: .inline)
        }
    }
}

#Preview {
    AddVehicleDetailsView(onAddCar: {_ in })
}
