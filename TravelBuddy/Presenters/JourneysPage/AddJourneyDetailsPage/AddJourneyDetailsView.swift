//
//  AddJourneyDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 29.01.25.
//

import SwiftUI
import MapKit
import FirebaseFirestore
import FirebaseAuth

struct AddJourneyDetailsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var journeyName = ""
    @State private var journeyDescription = ""
    @State private var journeyDate = Date()
    @State private var showDatePicker = false
    @State private var formattedDate: String = ""
    
    @StateObject private var viewModel = AddJourneyDetailsViewModel()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("Journey Details")) {
                        VStack(alignment: .leading) {
                            Text("Name Journey")
                                .foregroundStyle(.deepBlue)
                                .font(.robotoRegular(size: 16))
                            
                            TextField("Journey name", text: $journeyName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundStyle(.stoneGrey)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Description")
                                .foregroundStyle(.deepBlue)
                                .font(.robotoRegular(size: 16))
                            
                            TextEditor(text: $journeyDescription)
                                .frame(minHeight: 100, maxHeight: 200)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.stoneGrey.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.top, 4)
                                .padding(.bottom, 4)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Set Date")
                                .foregroundStyle(.deepBlue)
                                .font(.robotoRegular(size: 16))
                            
                            HStack {
                                TextField("DD/MM/YYYY", text: $formattedDate)
                                    .foregroundStyle(.stoneGrey)
                                    .disabled(true)
                                
                                Button(action: {
                                    showDatePicker.toggle()
                                }) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.stoneGrey)
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("Choose Route")) {
                        ZStack {
                            Map(coordinateRegion: $viewModel.region,
                                showsUserLocation: true,
                                annotationItems: viewModel.pinnedLocations) { location in
                                MapAnnotation(coordinate: location.coordinate) {
                                    Image(systemName: "mappin.circle.fill")
                                        .resizable()
                                        .foregroundColor(.burgundyRed)
                                        .frame(width: 30, height: 30)
                                }
                            }
                                .frame(height: 300)
                                .cornerRadius(8)
                                .shadow(color: Color.primaryBlack.opacity(0.25), radius: 4, x: 2, y: 2)
                                .onLongPressGesture {
                                    let location = viewModel.region.center
                                    viewModel.pinLocation(at: location)
                                }
                            
                            if let distance = viewModel.distanceToPin {
                                Text("Distance: \(String(format: "%.2f", distance)) km")
                                    .font(.robotoRegular(size: 16))
                                    .foregroundColor(.deepBlue)
                                    .padding(8)
                                    .background(Color.primaryWhite.opacity(0.8))
                                    .cornerRadius(8)
                                    .padding()
                            }
                        }
                    }
                    
                    Button("Save Journey") {
                        saveJourneyToFirestore()
                    }
                    .foregroundStyle(.deepBlue)
                }
                .background(Color(.systemBackground))
            }
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
            .onTapGesture {
                endEditing()
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    Text("Select Date")
                        .font(.title2)
                        .padding()
                    
                    DatePicker("", selection: $journeyDate, displayedComponents: .date)
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                        .padding()
                    
                    Button("Done") {
                        formattedDate = dateFormatter.string(from: journeyDate)
                        showDatePicker = false
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                }
                .presentationDetents([.medium, .large])
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func saveJourneyToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else {
            alertMessage = "No user logged in!"
            showAlert = true
            return
        }
        
        let distance = viewModel.distanceToPin ?? 0.0
        
        if journeyName.isEmpty {
            alertMessage = "Please enter a journey name."
            showAlert = true
            return
        }
        if journeyDescription.isEmpty {
            alertMessage = "Please enter a journey description."
            showAlert = true
            return
        }
        if formattedDate.isEmpty {
            alertMessage = "Please select a date."
            showAlert = true
            return
        }
        if viewModel.pinnedLocations.isEmpty {
            alertMessage = "Please set at least one pin on the map."
            showAlert = true
            return
        }
        if distance <= 0 {
            alertMessage = "Invalid distance. Please check your pinned location."
            showAlert = true
            return
        }
        
        let db = Firestore.firestore()
        
        db.collection("users").document(userId).collection("journeys").addDocument(data: [
            "journeyName": journeyName,
            "description": journeyDescription,
            "date": Timestamp(date: journeyDate),
            "distanceKm": distance
        ]) { error in
            if let error = error {
                print("Error saving journey: \(error)")
                alertMessage = "Failed to save journey."
                showAlert = true
            } else {
                print("Journey successfully saved to Firestore!")
                dismiss()
            }
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AddJourneyDetailsView()
}
