//
//  PersonalDetailsViewModel.swift
//  TravelBuddy
//
//  Created by MacBook on 01.02.25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class PersonalDetailsViewModel: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var isImagePickerPresented = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Published var userName: String
    @Published var userEmail: String
    
    init(userName: String, userEmail: String) {
        self.userName = userName
        self.userEmail = userEmail
    }
    
    func showImagePicker(source: UIImagePickerController.SourceType) {
        self.sourceType = source
        self.isImagePickerPresented = true
    }
    
    func deleteAccount(completion: @escaping (Bool) -> Void) {
        guard let user = Auth.auth().currentUser else {
            completion(false)
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(user.uid)
        
        deleteUserCollections(from: userRef) { success in
            if success {
                userRef.delete { error in
                    if let error = error {
                        print("❌ Error deleting user document: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("✅ User document deleted from Firestore.")
                        
                        user.delete { error in
                            if let error = error {
                                print("❌ Error deleting Firebase Auth account: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                print("✅ Firebase Authentication account deleted successfully.")
                                try? Auth.auth().signOut()
                                
                                DispatchQueue.main.async {
                                    if let sceneDelegate = UIApplication.shared.connectedScenes
                                        .first?.delegate as? SceneDelegate {
                                        sceneDelegate.switchToSignInVC()
                                    }
                                }
                                
                                completion(true)
                            }
                        }
                    }
                }
            } else {
                print("❌ Failed to delete all user collections.")
                completion(false)
            }
        }
    }
    
    private func deleteUserCollections(from documentRef: DocumentReference, completion: @escaping (Bool) -> Void) {
        let collections = ["vehicles", "journeys", "archivedJourneys"]
        let deleteGroup = DispatchGroup()
        
        for collection in collections {
            deleteGroup.enter()
            documentRef.collection(collection).getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching \(collection): \(error.localizedDescription)")
                    deleteGroup.leave()
                } else {
                    let documents = snapshot?.documents ?? []
                    for document in documents {
                        deleteGroup.enter()
                        document.reference.delete { error in
                            if let error = error {
                                print("❌ Error deleting document in \(collection): \(error.localizedDescription)")
                            }
                            deleteGroup.leave()
                        }
                    }
                    deleteGroup.leave()
                }
            }
        }
        
        deleteGroup.notify(queue: .main) {
            print("✅ All subcollections deleted.")
            completion(true)
        }
    }
    
    private func deleteUserSubcollections(from documentRef: DocumentReference, completion: @escaping (Bool) -> Void) {
        documentRef.collection("other_collection").getDocuments { snapshot, error in
            if let error = error {
                print("❌ Error fetching other collections: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            let deleteGroup = DispatchGroup()
            for document in snapshot!.documents {
                deleteGroup.enter()
                document.reference.delete { error in
                    if let error = error {
                        print("❌ Error deleting other collection document: \(error.localizedDescription)")
                    }
                    deleteGroup.leave()
                }
            }
            
            deleteGroup.notify(queue: .main) {
                completion(true)
            }
        }
    }
}
