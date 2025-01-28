//
//  JourneysView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct JourneysView: View {
    
    @State private var showAddJourneySheet = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            emptyView
        }
        .sheet(isPresented: $showAddJourneySheet) {
            AddJourneyDetailsView()
        }
    }
    
    private var emptyView: some View {
        VStack {
            Image("journey")
                .resizable()
                .frame(width: 200, height: 200).opacity(0.5)
                .padding()
            
            Button("Start Journey with Travel Buddy") {
                showAddJourneySheet.toggle()
            }
            .foregroundStyle(.deepBlue)
            .font(.robotoBold(size: 16))
        }
    }
}

#Preview {
    JourneysView()
}
