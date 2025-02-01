//
//  PersonalDetailsView.swift
//  TravelBuddy
//
//  Created by MacBook on 26.01.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PersonalDetailsView: View {
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage? = nil
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.dismiss) var dismiss
    
    var userName: String
    var userEmail: String
    var onChangePassword: () -> Void
    
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
                deleteAccountButton
                Spacer()
            }
            .sheet(isPresented: $isImagePickerPresented) {
                ImagePicker(selectedImage: $selectedImage, sourceType: sourceType)
            }
        }
    }
    
    private var backButton: some View {
           VStack {
               HStack {
                   ReusableBackButtonWrapper(action: {
                       dismiss()
                   })
                   .frame(width: 24, height: 24)
                   Spacer()
               }
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
                
                if let selectedImage = selectedImage {
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
                        self.sourceType = .camera
                        self.isImagePickerPresented.toggle()
                    }))
                    actionSheet.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { _ in
                        self.sourceType = .photoLibrary
                        self.isImagePickerPresented.toggle()
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
            
            Text(userName)
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
            
            Text(userEmail)
                .foregroundStyle(.deepBlue)
                .font(.robotoRegular(size: 16))
                .padding(.vertical)
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    private var changePasswordButton: some View {
        VStack {
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
            }
        }
        .padding(.horizontal)
    }
    
    private var deleteAccountButton: some View {
        Button(action: {
            deleteAccount()
        }) {
            Text("Delete Account")
                .foregroundStyle(.burgundyRed)
                .font(.robotoRegular(size: 20))
                .padding()
        }
        .frame(height: 46)
        .frame(maxWidth: .infinity)
        .border(.burgundyRed, width: 2)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.top)
    }
    
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else { return }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        deleteUserCollections(from: userRef) { success in
            if success {
                userRef.delete { error in
                    if let error = error {
                        print("Error deleting user data from Firestore: \(error.localizedDescription)")
                    } else {
                        print("User data deleted from Firestore.")
                    }
                }
            } else {
                print("Failed to delete user collections.")
            }
        }
        
        user.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                print("Account deleted successfully!")
                
                try? Auth.auth().signOut()
                
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let sceneDelegate = windowScene.delegate as? SceneDelegate {
                    sceneDelegate.switchToSignInVC()
                }
            }
        }
    }
    
    private func deleteUserCollections(from documentRef: DocumentReference, completion: @escaping (Bool) -> Void) {
        documentRef.collection("vehicles").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching vehicles collection: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            let deleteGroup = DispatchGroup()
            for document in snapshot!.documents {
                deleteGroup.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting vehicle document: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.notify(queue: .main) {
                // Recursively delete other subcollections
                self.deleteUserSubcollections(from: documentRef) { success in
                    completion(success)
                }
            }
        }
    }
    
    private func deleteUserSubcollections(from documentRef: DocumentReference, completion: @escaping (Bool) -> Void) {
        documentRef.collection("other_collection").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching other collections: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            let deleteGroup = DispatchGroup()
            for document in snapshot!.documents {
                deleteGroup.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("Error deleting other collection document: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.notify(queue: .main) {
                completion(true)
            }
        }
    }
    
    private func getNavigationController() -> UINavigationController? {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let navController = windowScene.windows.first?.rootViewController as? UINavigationController {
                return navController
            }
        }
        return nil
    }
}

#Preview {
    PersonalDetailsView(userName: "Ana Kochievi", userEmail: "anna.kochievi@gmail.com", onChangePassword: {})
}
