//
//  ActiveViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 29/12/23.
//

import Foundation
import FirebaseAuth
import FirebaseCore

class ActiveViewModel : ObservableObject {
    
    @Published var users = [User]()
    
    init(){
        Task{ try await fetchUser() }
    }
    
    @MainActor
    private func fetchUser() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let users = try await UserService.fetchAllUsers()
        self.users = users.filter({ $0.id != currentUid })
    }
}
