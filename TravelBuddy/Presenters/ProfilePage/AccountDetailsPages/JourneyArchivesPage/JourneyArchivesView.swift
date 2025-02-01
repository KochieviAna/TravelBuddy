//
//  JourneyArchivesView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct JourneyArchivesView: View {
    @State private var archivedJourneys: [ArchivedJourney] = []
    private let db = Firestore.firestore()
    
    var onSelectJourney: (ArchivedJourney) -> Void
    
    var body: some View {
        NavigationView {
            List(archivedJourneys) { journey in
                Button(action: {
                    onSelectJourney(journey)
                }) {
                    VStack(alignment: .leading) {
                        Text(journey.journeyName)
                            .font(.headline)
                        Text("Date: \(formattedDate(from: journey.date))")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Archived Journeys")
            .foregroundStyle(.deepBlue)
            .navigationBarBackButtonHidden(true)
            .onAppear {
                fetchArchivedJourneys()
            }
        }
    }
    
    private func fetchArchivedJourneys() {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("archivedJourneys")
            .order(by: "date", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching archived journeys: \(error)")
                } else {
                    self.archivedJourneys = snapshot?.documents.compactMap { document in
                        try? document.data(as: ArchivedJourney.self)
                    } ?? []
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
    JourneyArchivesView(onSelectJourney: {_ in })
}
