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
            Image(systemName: imageName)
                .frame(width: 20, height: 20)
                .foregroundColor(Color("deepBlue"))
            
            Text(text)
                .font(.robotoMedium(size: 16))
                .foregroundColor(Color("deepBlue"))
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .frame(width: 10, height: 10)
                .foregroundColor(Color("deepBlue").opacity(0.5))
        }
        .padding(.vertical, 10)
        .padding()
    }
}

#Preview {
    ProfileListItem(imageName: "car", text: "Vehicle details")
}
