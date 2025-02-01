//
//  AddVehicleDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 28.01.25.
//

import SwiftUI

struct AddVehicleDetailsView: View {
    @StateObject private var viewModel = AddVehicleDetailsViewModel()
    var onAddCar: (Car) -> Void
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                Form {
                    Section(header: Text("General Information")) {
                        TextField("Brand", text: $viewModel.brand)
                            .foregroundStyle(.deepBlue)
                        
                        TextField("Model", text: $viewModel.model)
                            .foregroundStyle(.deepBlue)
                        
                        TextField("Year", text: $viewModel.year)
                            .foregroundStyle(.deepBlue)
                        
                        Picker("Engine Type", selection: $viewModel.engineType) {
                            Text("Gasoline").tag("Gasoline")
                            Text("Electric").tag("Electric")
                            Text("Hybrid").tag("Hybrid")
                            Text("Diesel").tag("Diesel")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Fuel Type", text: $viewModel.fuelType)
                            .foregroundStyle(.deepBlue)
                    }
                    
                    if viewModel.engineType == "Gasoline" {
                        fuelFields
                    }
                    
                    if viewModel.engineType == "Electric" {
                        electricFields
                    }
                    
                    if viewModel.engineType == "Hybrid" {
                        hybridFields
                    }
                    
                    if viewModel.engineType == "Diesel" {
                        fuelFields
                    }
                    
                    Button("Save Vehicle") {
                        if viewModel.validateFields() {
                            viewModel.saveVehicleToFirestore { car in
                                onAddCar(car)
                            }
                        } else {
                            viewModel.showAlert = true
                        }
                    }
                    .foregroundStyle(.deepBlue)
                }
            }
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Vehicle")
                        .font(.robotoBold(size: 20))
                        .foregroundColor(.deepBlue)
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Missing Information"), message: Text("Please fill in all fields before saving."), dismissButton: .default(Text("OK")))
            }
            .onTapGesture {
                endEditing()
            }
        }
    }
    
    private var fuelFields: some View {
        Section(header: Text("Fuel Vehicle Information")) {
            TextField("Fuel Tank Capacity (gallons)", text: $viewModel.fuelTankCapacity)
                .foregroundStyle(.deepBlue)
            
            TextField("Fuel Consumption (MPG)", text: $viewModel.fuelConsumptionMpg)
                .foregroundStyle(.deepBlue)
            
            TextField("CO2 Emissions (g/mi)", text: $viewModel.co2Emission)
                .foregroundStyle(.deepBlue)
        }
    }
    
    private var electricFields: some View {
        Section(header: Text("Electric Vehicle Information")) {
            TextField("Battery Capacity (kWh)", text: $viewModel.batteryCapacityElectric)
                .foregroundStyle(.deepBlue)
            
            TextField("EPA Electric Consumption (kWh/100mi)", text: $viewModel.epaKwh100MiElectric)
                .foregroundStyle(.deepBlue)
        }
    }
    
    private var hybridFields: some View {
        Section(header: Text("Hybrid Vehicle Information")) {
            TextField("CO2 Emissions (g/mi)", text: $viewModel.co2Emission)
                .foregroundStyle(.deepBlue)
            
            TextField("Hybrid Fuel Efficiency (MPG)", text: $viewModel.hybridEfficiency)
                .foregroundStyle(.deepBlue)
            
            TextField("Electric Range (miles)", text: $viewModel.electricRange)
                .foregroundStyle(.deepBlue)
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddVehicleDetailsView(onAddCar: {_ in })
}
