//
//  PersonalDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI

struct PersonalDetailsView: View {
    @StateObject private var viewModel: PersonalDetailsViewModel
    @Environment(\.dismiss) var dismiss
    
    var onChangePassword: () -> Void
    
    init(userName: String, userEmail: String, onChangePassword: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: PersonalDetailsViewModel(userName: userName, userEmail: userEmail))
        self.onChangePassword = onChangePassword
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()
            
            VStack {
                backButton
                
                profileHeader
                
                nameAndSurnameView
                
                emailView
                
                changePasswordButton
                
                Spacer()
                
                deleteAccountButton
                
                Spacer()
            }
            .sheet(isPresented: $viewModel.isImagePickerPresented) {
                ImagePicker(selectedImage: $viewModel.selectedImage, sourceType: viewModel.sourceType)
            }
        }
    }
    
    private var backButton: some View {
        HStack {
            ReusableBackButtonWrapper(action: {
                dismiss()
            })
            .frame(width: 24, height: 24)
            Spacer()
        }
        .padding()
    }
    
    private var profileHeader: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .frame(width: 120)
                    .foregroundStyle(Color("primaryWhite"))
                    .shadow(color: Color("primaryBlack").opacity(0.25), radius: 1, x: 1, y: 1)
                    .shadow(color: Color("primaryBlack").opacity(0.25), radius: 1, x: -1, y: -1)
                
                if let selectedImage = viewModel.selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 102, height: 102)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .frame(width: 102, height: 102)
                        .foregroundColor(Color("stoneGrey"))
                }
                
                Button(action: {
                    let actionSheet = UIAlertController(title: "Choose Photo", message: nil, preferredStyle: .actionSheet)
                    actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                        viewModel.showImagePicker(source: .camera)
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
                        viewModel.showImagePicker(source: .photoLibrary)
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        if let rootViewController = windowScene.windows.first?.rootViewController {
                            rootViewController.present(actionSheet, animated: true)
                        }
                    }
                }) {
                    Text("Upload Picture")
                        .font(.robotoBold(size: 16))
                        .foregroundColor(.deepBlue)
                        .padding(.top, 160)
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal)
    }
    
    private var nameAndSurnameView: some View {
        HStack {
            Image(systemName: "person")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(.deepBlue)
            
            Text(viewModel.userName)
                .foregroundStyle(.deepBlue)
                .font(.robotoRegular(size: 16))
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var emailView: some View {
        HStack {
            Image(systemName: "envelope")
                .resizable()
                .frame(width: 24, height: 20)
                .foregroundStyle(.deepBlue)
            
            Text(viewModel.userEmail)
                .foregroundStyle(.deepBlue)
                .font(.robotoRegular(size: 16))
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var changePasswordButton: some View {
        Button(action: {
            onChangePassword()
        }) {
            HStack {
                Image(systemName: "lock")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.deepBlue)
                
                Text("Change password")
                    .foregroundStyle(.deepBlue)
                    .font(.robotoRegular(size: 16))
                    .padding(.vertical)
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            viewModel.deleteAccount { success in
                if success {
                    dismiss()
                }
            }
        }) {
            Text("Delete Account")
                .foregroundStyle(.burgundyRed)
                .font(.robotoRegular(size: 20))
                .padding()
        }
    }
}

#Preview {
    PersonalDetailsView(userName: "Ana Kochievi", userEmail: "anna.kochievi@gmail.com", onChangePassword: {})
}
