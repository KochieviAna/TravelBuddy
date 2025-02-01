//
//  AddVehicleDetailsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AddVehicleDetailsViewModel: ObservableObject {
    @Published var brand = ""
    @Published var model = ""
    @Published var year = ""
    @Published var engineType = "Gasoline"
    @Published var fuelType = ""
    @Published var fuelTankCapacity = ""
    @Published var fuelConsumptionMpg = ""
    @Published var co2Emission = ""
    @Published var batteryCapacityElectric = ""
    @Published var epaKwh100MiElectric = ""
    @Published var hybridEfficiency = ""
    @Published var electricRange = ""
    
    @Published var showAlert = false
    
    func validateFields() -> Bool {
        return !brand.isEmpty && !model.isEmpty && !year.isEmpty && !fuelType.isEmpty &&
        (!fuelTankCapacity.isEmpty || engineType == "Electric" || engineType == "Diesel") &&
        !fuelConsumptionMpg.isEmpty && !co2Emission.isEmpty &&
        (engineType != "Electric" || (!batteryCapacityElectric.isEmpty && !epaKwh100MiElectric.isEmpty)) &&
        (engineType != "Hybrid" || (!hybridEfficiency.isEmpty && !electricRange.isEmpty)) &&
        (engineType != "Diesel" || !fuelTankCapacity.isEmpty)
    }

    func saveVehicleToFirestore(onAddCar: @escaping (Car) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No user is logged in")
            return
        }
        
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
        
        let db = Firestore.firestore()
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
                print("✅ Vehicle successfully added to Firestore!")
                if let id = ref?.documentID {
                    var updatedCar = car
                    updatedCar.id = id
                    DispatchQueue.main.async {
                        onAddCar(updatedCar)
                    }
                }
            }
        }
    }
}
