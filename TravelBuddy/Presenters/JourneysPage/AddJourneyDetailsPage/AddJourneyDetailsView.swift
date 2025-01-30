//
//  AddJourneyDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 29.01.25.
//

import SwiftUI
import MapKit

struct AddJourneyDetailsView: View {
    
    @State private var journeyName = ""
    @State private var journeyDate = Date()
    @State private var showDatePicker = false
    @State private var formattedDate: String = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Journey Details")) {
                    TextField("Add name of journey", text: $journeyName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundStyle(.stoneGrey)
                    
                    HStack {
                        TextField("DD/MM/YYYY", text: $formattedDate)
                            .foregroundStyle(.stoneGrey)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: formattedDate) {
                                if let date = dateFormatter.date(from: formattedDate) {
                                    journeyDate = date
                                }
                            }
                        
                        Button(action: {
                            showDatePicker.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .foregroundColor(.deepBlue)
                        }
                    }
                    .padding()
                    
                    if showDatePicker {
                        DatePicker("", selection: $journeyDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .onChange(of: journeyDate) {
                                formattedDate = dateFormatter.string(from: journeyDate)
                            }
                    }
                }
                
                Section(header: Text("Choose Route")) {
                    Map()
                        .frame(height: 300)
                        .cornerRadius(8)
                        .shadow(color: Color.primaryBlack.opacity(0.25), radius: 4, x: 2, y: 2)
                }
            }
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Journey")
                        .font(.robotoBold(size: 20))
                        .foregroundColor(.deepBlue)
                }
            }
            .foregroundStyle(.stoneGrey)
            .onAppear {
                formattedDate = dateFormatter.string(from: journeyDate)
            }
        }
    }
}

#Preview {
    AddJourneyDetailsView()
}
