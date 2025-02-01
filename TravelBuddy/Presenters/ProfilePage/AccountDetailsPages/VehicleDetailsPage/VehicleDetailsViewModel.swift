//
//  VehicleDetailsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class VehicleDetailsViewModel: ObservableObject {
    @Published var selectedCar: Car? = nil
    @Published var isAddingCar = false
    private var db = Firestore.firestore()

    init() {
        fetchVehicle()
    }

    func fetchVehicle() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in!")
            return
        }
        
        db.collection("users").document(userId).collection("vehicles").limit(to: 1).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching vehicle: \(error)")
            } else {
                if let document = snapshot?.documents.first {
                    let car = try? document.data(as: Car.self)
                    DispatchQueue.main.async {
                        self.selectedCar = car
                    }
                } else {
                    print("No vehicle found!")
                    DispatchQueue.main.async {
                        self.selectedCar = nil
                    }
                }
            }
        }
    }

    func deleteVehicle() {
        guard let car = selectedCar, let carId = car.id else {
            print("Car ID is missing!")
            return
        }

        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not logged in!")
            return
        }

        db.collection("users").document(userId).collection("vehicles").document(carId).delete { error in
            if let error = error {
                print("Error deleting vehicle: \(error)")
            } else {
                print("✅ Vehicle deleted from Firestore")
                DispatchQueue.main.async {
                    self.selectedCar = nil
                }
            }
        }
    }

    func addVehicle(_ car: Car) {
        DispatchQueue.main.async {
            self.selectedCar = car
            self.isAddingCar = false
        }
    }
}
