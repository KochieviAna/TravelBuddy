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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                ReusableBackButtonWrapper {
                    presentationMode.wrappedValue.dismiss()
                }
                .frame(width: 44, height: 44)
                
                Spacer()
            }
            .background(Color(.systemBackground))
            .padding(.leading)
            
            List(archivedJourneys) { journey in
                Button(action: {
                    onSelectJourney(journey)
                }) {
                    VStack(alignment: .leading) {
                        Text(journey.journeyName)
                            .font(.robotoSemiBold(size: 15))
                            .foregroundColor(.deepBlue)
                        
                        Text("Date: \(formattedDate(from: journey.date))")
                            .font(.robotoRegular(size: 14))
                            .foregroundColor(.deepBlue)
                    }
                }
            }
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            fetchArchivedJourneys()
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
