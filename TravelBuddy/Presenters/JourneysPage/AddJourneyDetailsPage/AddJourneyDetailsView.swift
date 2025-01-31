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
    @State private var journeyDescription = ""
    @State private var journeyDate = Date()
    @State private var showDatePicker = false
    @State private var formattedDate: String = ""
    
    @StateObject private var viewModel = AddJourneyDetailsViewModel()
    
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
                                .foregroundStyle(.deepBlue)
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
                                        .foregroundColor(.stoneGrey)
                                }
                            }
                        }
                        
                        if showDatePicker {
                            DatePicker("", selection: $journeyDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                                .onChange(of: journeyDate) {
                                    formattedDate = dateFormatter.string(from: journeyDate)
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
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { value in
                                        let location = convertTapToLocation(value.location, in: viewModel.region)
                                        viewModel.pinLocation(at: location)
                                    }
                            )
                            
                            if let distance = viewModel.distanceToPin {
                                Text("Distance: \(String(format: "%.2f", distance)) km")
                                    .font(.robotoRegular(size: 16))
                                    .foregroundColor(.deepBlue)
                                    .padding(8)
                                    .background(Color.white.opacity(0.8))
                                    .cornerRadius(8)
                                    .padding()
                            }
                        }
                    }
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
        }
    }
    
    private func endEditing() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func convertTapToLocation(_ tapLocation: CGPoint, in region: MKCoordinateRegion) -> CLLocationCoordinate2D {
        let span = region.span
        let center = region.center
        
        let mapWidth = UIScreen.main.bounds.width
        let mapHeight: CGFloat = 300 // Same height as the map view
        
        let longitude = center.longitude + (Double(tapLocation.x / mapWidth) - 0.5) * span.longitudeDelta
        let latitude = center.latitude - (Double(tapLocation.y / mapHeight) - 0.5) * span.latitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    AddJourneyDetailsView()
}
