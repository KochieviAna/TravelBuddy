//
//  ProfileView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct ProfileView: View {
    var userName: String
    var userEmail: String
    
    let listItems = [
        (imageName: "person", text: "Personal Details"),
        (imageName: "archivebox", text: "Journey Archives"),
        (imageName: "car", text: "Vehicle Details")
    ]
    
    var navigateToDetail: (String) -> Void
    var logoutAction: () -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .frame(width: 120)
                            .foregroundStyle(Color("primaryWhite"))
                            .shadow(color: Color("primaryBlack").opacity(0.25), radius: 1, x: 1, y: 1)
                            .shadow(color: Color("primaryBlack").opacity(0.25), radius: 1, x: -1, y: -1)
                        
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 102)
                            .foregroundColor(Color("stoneGrey"))
                    }
                    .padding(.bottom, 20)
                    
                    Text(userName)
                        .font(.robotoSemiBold(size: 20))
                        .foregroundColor(Color("deepBlue"))
                    
                    Text(userEmail)
                        .font(.robotoMedium(size: 16))
                        .foregroundColor(Color("deepBlue").opacity(0.5))
                    
                    HStack {
                        Text("Account")
                            .font(.robotoMedium(size: 16))
                            .foregroundColor(Color("deepBlue"))
                        Spacer()
                    }
                    .padding(.top, 18)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                
                VStack(spacing: 15) {
                    ForEach(listItems, id: \.text) { item in
                        Button(action: {
                            navigateToDetail(item.text)
                        }) {
                            ProfileListItem(imageName: item.imageName, text: item.text)
                        }
                        .background(Color("primaryWhite"))
                        .cornerRadius(10)
                    }
                }
                .padding(.horizontal)
                
                ReusableButtonWrapper(title: "Logout", action: logoutAction)
                    .padding(.top, 30)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .padding(.top)
        .background(Color(.systemBackground))
        .onDisappear {
            print("ProfileView deallocated")
        }
    }
}

#Preview {
    ProfileView(userName: "Ana Kochievi", userEmail: "anna.kochievi@gmail.com", navigateToDetail: {_ in }, logoutAction: { })
}
