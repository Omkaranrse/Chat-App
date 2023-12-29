//
//  AuthService.swift
//  ChatApp
//
//  Created by Omkar Anarse on 25/12/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseFirestore

class AuthService {
    
    @Published var userSession : FirebaseAuth.User?
    static let shared = AuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
        print("User session id is \(String(describing: userSession?.uid))")
    }
    
    @MainActor
    func login(withEmail email : String, password: String) async throws {
        do{
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        }catch{
            print("Error failed to sign in user \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email : String, password: String, fullName: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // create user
            self.userSession = result.user
            try await self.uploadUserData(id: result.user.uid, email: email, fullName: fullName) // upload user data
            loadCurrentUserData()
        } catch {
            print("Error failed to create user\(error.localizedDescription)")
        }
    }
    
    func signOut(){
        do{
            try Auth.auth().signOut() //signs out on backend
            self.userSession = nil //updates routing logic
            UserService.shared.currentUser = nil
        } catch {
            print("Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    //Upload user data and store data
    private func uploadUserData(id: String, email: String, fullName: String) async throws {
        let user = User(fullName: fullName, email: email, profileImageUrl: nil)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    private func loadCurrentUserData(){
        Task{ try await UserService.shared.fetchCurrentUser() }
    }
}
