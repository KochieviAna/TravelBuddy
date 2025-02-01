//
//  VehicleDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct VehicleDetailsView: View {
    @StateObject private var viewModel = VehicleDetailsViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            if let car = viewModel.selectedCar {
                vehicleDetailsView(for: car)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                emptyView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .sheet(isPresented: $viewModel.isAddingCar) {
            AddVehicleDetailsView(onAddCar: { car in
                viewModel.addVehicle(car)
            })
        }
    }

    private var emptyView: some View {
        VStack {
            HStack {
                ReusableBackButtonWrapper(action: {
                    dismiss()
                })
                .frame(width: 24, height: 24)

                Spacer()

                Button(action: {
                    viewModel.isAddingCar = true
                }) {
                    Image(systemName: "plus")
                }
                .foregroundStyle(.deepBlue)
            }
            .padding(.horizontal)

            Image(systemName: "car")
                .resizable()
                .frame(width: 120, height: 100)
                .foregroundStyle(.deepBlue)
                .padding(.top, 150)

            Text("No Vehicle Available")
                .font(.robotoSemiBold(size: 15))
                .foregroundStyle(.deepBlue)
                .opacity(0.7)

            Spacer()
        }
    }

    private func vehicleDetailsView(for car: Car) -> some View {
        VStack(alignment: .leading) {
            HStack {
                ReusableBackButtonWrapper(action: {
                    dismiss()
                })
                .frame(width: 24, height: 24)

                Spacer()

                Text("Vehicle Details")
                    .font(.robotoBold(size: 35))
                    .foregroundStyle(.deepBlue)

                Spacer()

                Button(action: {
                    viewModel.deleteVehicle()
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.deepBlue)
                }
            }

            Text("Brand: \(car.brand)")
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)
                .padding(.top)

            Text("Model: \(car.model)")
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)

            Text("Year: \(car.year)")
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)

            Text("Engine Type: \(car.engineType)")
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)

            Text("Fuel Type: \(car.fuelType)")
                .font(.robotoRegular(size: 20))
                .foregroundStyle(.deepBlue)

            if car.engineType == "Gasoline" {
                Text("Fuel Tank Capacity: \(car.fuelTankCapacity, specifier: "%.1f") Gallons")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("Fuel Consumption: \(car.fuelConsumptionMpg, specifier: "%.1f") MPG")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("CO2 Emissions: \(car.co2Emission) g/km")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)
            }

            if car.engineType == "Electric" {
                Text("Battery Capacity: \(car.batteryCapacityElectric, specifier: "%.1f") kWh")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("EPA Electric Consumption: \(car.epaKwh100MiElectric, specifier: "%.1f") kWh/100mi")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)
            }

            if car.engineType == "Hybrid" {
                Text("Hybrid Fuel Efficiency: \(car.hybridEfficiency, specifier: "%.1f") MPG")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("Electric Range: \(car.electricRange, specifier: "%.1f") miles")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)
            }

            if car.engineType == "Diesel" {
                Text("Fuel Tank Capacity: \(car.fuelTankCapacity, specifier: "%.1f") Gallons")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("Fuel Consumption: \(car.fuelConsumptionMpg, specifier: "%.1f") MPG")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)

                Text("CO2 Emissions: \(car.co2Emission) g/km")
                    .font(.robotoRegular(size: 20))
                    .foregroundStyle(.deepBlue)
            }

            Spacer()
        }
        .padding(.horizontal)
    }
}

#Preview {
    VehicleDetailsView()
}
