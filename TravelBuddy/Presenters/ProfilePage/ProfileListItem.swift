//
//  ProfileListItem.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct ProfileListItem: View {
    var imageName: String
    var text: String
    
    var body: some View {
        HStack {
            icon
            label
            Spacer()
            chevron
        }
        .padding(.vertical, 10)
        .padding()
    }
    
    private var icon: some View {
        Image(systemName: imageName)
            .frame(width: 20, height: 20)
            .foregroundColor(Color("deepBlue"))
    }
    
    private var label: some View {
        Text(text)
            .font(.robotoMedium(size: 16))
            .foregroundColor(Color("deepBlue"))
    }
    
    private var chevron: some View {
        Image(systemName: "chevron.right")
            .frame(width: 10, height: 10)
            .foregroundColor(Color("deepBlue").opacity(0.5))
    }
}

#Preview {
    ProfileListItem(imageName: "car", text: "Vehicle Details")
}
