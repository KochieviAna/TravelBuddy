//
//  StatisticsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class StatisticsViewModel: ObservableObject {
    @Published var archivedJourneys: [ArchivedJourney] = []
    
    private let db = Firestore.firestore()
    
    // ✅ Filtering Mechanism for Hiding Empty Charts
    var hasFuelData: Bool { archivedJourneys.contains { Double($0.fuelNeeded ?? "0") ?? 0 > 0 } }
    var hasCO2Data: Bool { archivedJourneys.contains { Double($0.co2Emissions ?? "0") ?? 0 > 0 } }
    var hasElectricData: Bool { archivedJourneys.contains { Double($0.electricConsumption ?? "0") ?? 0 > 0 } }
    var hasDistanceData: Bool { archivedJourneys.contains { $0.distanceKm > 0 } }
    
    var dates: [Date] {
        archivedJourneys.map { $0.date }
    }

    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM" // 🗓️ Format for X-axis
        return formatter
    }()
    
    func fetchArchivedJourneys() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("archivedJourneys")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching archived journeys: \(error)")
                } else {
                    DispatchQueue.main.async {
                        self.archivedJourneys = snapshot?.documents.compactMap { document in
                            try? document.data(as: ArchivedJourney.self)
                        } ?? []
                    }
                }
            }
    }
}
