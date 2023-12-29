//
//  ProfileViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import Foundation
import SwiftUI
import PhotosUI
import UIKit
import FirebaseFirestore
import FirebaseAuth

@MainActor
class ProfileViewModel  : ObservableObject {

    @Published var user : User
    
    @Published var selectedImage : PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    
    @Published var profileImage : Image?
    
    private var uiImage : UIImage?

    init(user : User){
        self.user = user
    }
    
    func loadImage(fromItem item :  PhotosPickerItem?) async {
        guard let item = item else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }

    
    func updateUserData() async throws {
        //update profile pic if changed
        var data = [String : Any]()
        
        if let uiImage = uiImage {
            let imageUrl = try? await ImageUploader.imageData(image: uiImage)
            data["profilePicture"] = imageUrl
        }
        
        if !data.isEmpty{
            try await Firestore.firestore().collection("users").document(user.id).updateData(data)
        }
    }
    
    @MainActor
    func fetchUserData() async throws {
        
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }

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
                }
            } catch {
                print("Error decoding user data: \(error.localizedDescription)")
            }
        }
    }

}
