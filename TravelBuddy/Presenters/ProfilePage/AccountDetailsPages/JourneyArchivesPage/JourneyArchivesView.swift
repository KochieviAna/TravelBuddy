//
//  JourneyArchivesView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct JourneyArchivesView: View {
    @StateObject private var viewModel = JourneyArchivesViewModel()
    
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
            
            List(viewModel.archivedJourneys) { journey in
                Button(action: {
                    onSelectJourney(journey)
                }) {
                    VStack(alignment: .leading) {
                        Text(journey.journeyName)
                            .font(.robotoSemiBold(size: 15))
                            .foregroundColor(.deepBlue)
                        
                        Text("Date: \(viewModel.formattedDate(from: journey.date))")
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
    }
}

#Preview {
    JourneyArchivesView(onSelectJourney: {_ in })
}
