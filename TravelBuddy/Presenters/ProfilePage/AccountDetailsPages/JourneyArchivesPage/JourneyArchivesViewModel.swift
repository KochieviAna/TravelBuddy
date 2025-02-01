//
//  JourneyArchivesViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class JourneyArchivesViewModel: ObservableObject {
    @Published var archivedJourneys: [ArchivedJourney] = []
    private let db = Firestore.firestore()
    
    init() {
        fetchArchivedJourneys()
    }
    
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
    
    func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}
