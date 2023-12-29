//
//  UserService.swift
//  ChatApp
//
//  Created by Omkar Anarse on 27/12/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class UserService {
    
    @Published var currentUser : User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let sanpshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        let user = try sanpshot.data(as: User.self) // decode
        self.currentUser = user
    }
    
    @MainActor
    static func fetchAllUsers() async throws -> [User]{
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap { try? $0.data(as: User.self) }
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(User) -> ()){
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            completion(user)
        }
    }
}
