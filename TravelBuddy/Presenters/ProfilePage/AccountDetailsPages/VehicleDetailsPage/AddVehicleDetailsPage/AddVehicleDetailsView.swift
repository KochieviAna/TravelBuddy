//
//  AddVehicleDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 28.01.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddVehicleDetailsView: View {
    
    var onAddCar: (Car) -> Void
    
    @State private var brand = ""
    @State private var model = ""
    @State private var year = ""
    @State private var engineType = "Gasoline"
    @State private var fuelType = ""
    @State private var fuelTankCapacity = ""
    @State private var fuelConsumptionMpg = ""
    @State private var co2Emission = ""
    @State private var batteryCapacityElectric = ""
    @State private var epaKwh100MiElectric = ""
    @State private var hybridEfficiency = ""
    @State private var electricRange = ""
    
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                Form {
                    Section(header: Text("General Information")) {
                        TextField("Brand", text: $brand)
                            .foregroundStyle(.deepBlue)
                        
                        TextField("Model", text: $model)
                            .foregroundStyle(.deepBlue)
                        
                        TextField("Year", text: $year)
                            .foregroundStyle(.deepBlue)
                        
                        Picker("Engine Type", selection: $engineType) {
                            Text("Gasoline").tag("Gasoline")
                                .foregroundStyle(.deepBlue)
                            
                            Text("Electric").tag("Electric")
                                .foregroundStyle(.deepBlue)
                            
                            Text("Hybrid").tag("Hybrid")
                                .foregroundStyle(.deepBlue)
                            
                            Text("Diesel").tag("Diesel")
                                .foregroundStyle(.deepBlue)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        TextField("Fuel Type", text: $fuelType)
                            .foregroundStyle(.deepBlue)
                    }
                    
                    if engineType == "Gasoline" {
                        Section(header: Text("Gasoline Vehicle Information")) {
                            TextField("Fuel Tank Capacity (gallons)", text: $fuelTankCapacity)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("Fuel Consumption (MPG)", text: $fuelConsumptionMpg)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("CO2 Emissions (g/mi)", text: $co2Emission)
                                .foregroundStyle(.deepBlue)
                        }
                    }
                    
                    if engineType == "Electric" {
                        Section(header: Text("Electric Vehicle Information")) {
                            TextField("Battery Capacity (kWh)", text: $batteryCapacityElectric)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("EPA Electric Consumption (kWh/100mi)", text: $epaKwh100MiElectric)
                                .foregroundStyle(.deepBlue)
                        }
                    }
                    
                    if engineType == "Hybrid" {
                        Section(header: Text("Hybrid Vehicle Information")) {
                            TextField("CO2 Emissions (g/mi)", text: $co2Emission)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("Hybrid Fuel Efficiency (MPG)", text: $hybridEfficiency)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("Electric Range (miles)", text: $electricRange)
                                .foregroundStyle(.deepBlue)
                        }
                    }
                    
                    if engineType == "Diesel" {
                        Section(header: Text("Diesel Vehicle Information")) {
                            TextField("Fuel Tank Capacity (gallons)", text: $fuelTankCapacity)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("Fuel Consumption (MPG)", text: $fuelConsumptionMpg)
                                .foregroundStyle(.deepBlue)
                            
                            TextField("CO2 Emissions (g/mi)", text: $co2Emission)
                                .foregroundStyle(.deepBlue)
                        }
                    }
                    
                    Button("Save Vehicle") {
                        if validateFields() {
                            let car = Car(
                                brand: brand,
                                model: model,
                                year: Int(year) ?? 0,
                                engineType: engineType,
                                fuelType: fuelType,
                                fuelTankCapacity: Double(fuelTankCapacity) ?? 0,
                                fuelConsumptionMpg: Double(fuelConsumptionMpg) ?? 0,
                                co2Emission: Double(co2Emission) ?? 0,
                                batteryCapacityElectric: Double(batteryCapacityElectric) ?? 0,
                                epaKwh100MiElectric: Double(epaKwh100MiElectric) ?? 0,
                                hybridEfficiency: Double(hybridEfficiency) ?? 0,
                                electricRange: Double(electricRange) ?? 0
                            )
                            saveVehicleToFirestore(car: car)
                            onAddCar(car)
                        } else {
                            showAlert = true
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
            .foregroundStyle(.stoneGrey)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Missing Information"), message: Text("Please fill in all fields before saving."), dismissButton: .default(Text("OK")))
            }
            .onTapGesture {
                endEditing()
            }
        }
    }
    
    private func validateFields() -> Bool {
        return !brand.isEmpty && !model.isEmpty && !year.isEmpty && !fuelType.isEmpty &&
        (!fuelTankCapacity.isEmpty || engineType == "Electric" || engineType == "Diesel") &&
        !fuelConsumptionMpg.isEmpty && !co2Emission.isEmpty &&
        (engineType != "Electric" || (!batteryCapacityElectric.isEmpty && !epaKwh100MiElectric.isEmpty)) &&
        (engineType != "Hybrid" || (!hybridEfficiency.isEmpty && !electricRange.isEmpty)) &&
        (engineType != "Diesel" || !fuelTankCapacity.isEmpty)
    }
    
    private func saveVehicleToFirestore(car: Car) {
        let db = Firestore.firestore()
        
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }
        
        var ref: DocumentReference? = nil
        ref = db.collection("users").document(userId).collection("vehicles").addDocument(data: [
            "brand": car.brand,
            "model": car.model,
            "year": car.year,
            "engineType": car.engineType,
            "fuelType": car.fuelType,
            "fuelTankCapacity": car.fuelTankCapacity,
            "fuelConsumptionMpg": car.fuelConsumptionMpg,
            "co2Emission": car.co2Emission,
            "batteryCapacityElectric": car.batteryCapacityElectric,
            "epaKwh100MiElectric": car.epaKwh100MiElectric,
            "hybridEfficiency": car.hybridEfficiency,
            "electricRange": car.electricRange
        ]) { error in
            if let error = error {
                print("Error adding vehicle to Firestore: \(error)")
            } else {
                print("Vehicle successfully added to Firestore!")
                if let id = ref?.documentID {
                    print("Saved Vehicle ID: \(id)")
                    var updatedCar = car
                    updatedCar.id = id
                    onAddCar(updatedCar)
                }
            }
        }
    }
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddVehicleDetailsView(onAddCar: {_ in })
}
