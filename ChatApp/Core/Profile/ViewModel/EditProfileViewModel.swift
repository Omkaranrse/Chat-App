//
//  EditProfileViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 29/12/23.
//


import PhotosUI
import Firebase
import SwiftUI
import FirebaseStorage
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


@MainActor
class EditProfileViewModel : ObservableObject {
    
    @Published var user : User
    @Published var selectedImage : PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImageUrl : Image?
    @Published var fullName : String = ""
    
    private var uiImage : UIImage?

    init(user : User){
        self.user = user
        
        if let fullName = user.fullName {
        self.fullName = fullName
        }
    }
    
    func loadImage(fromItem item :  PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImageUrl = Image(uiImage: uiImage)
    }

    func updateUserData() async throws {
        var data = [String : Any]()
        
        // Update profile pic if changed
        if let uiImage = uiImage {
            let imageUrl = try? await ImageUploader.uploadImage(image: uiImage)
            data["profileImageUrl"] = imageUrl
        }
        
        // Update profile name if changed
        if !fullName.isEmpty && user.fullName != fullName {
            data["fullName"] = fullName
        }
                
        if !data.isEmpty {
            do {
                let userRef = Firestore.firestore().collection("users").document(user.id)
                try await userRef.updateData(data)
            } catch {
                print("Error updating user data: \(error.localizedDescription)")
            }
        }
    }
    
    @MainActor
    func fetchUserData() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {return}

        let documentReference = Firestore.firestore().collection("users").document(userId)

        // Add a snapshot listener to observe changes
        documentReference.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }

            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            guard let document = snapshot else {
                print("Document does not exist")
                return
            }

            do {
                if document.exists {
                    let updatedUser = try document.data(as: User.self, decoder: Firestore.Decoder())
                    // Update the local user object with the fetched data
                    self.user = updatedUser

                    // Update other properties based on the fetched data
                    if let fullName = updatedUser.fullName {
                        self.fullName = fullName
                    }
                }
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
            }
        }
    }
}

