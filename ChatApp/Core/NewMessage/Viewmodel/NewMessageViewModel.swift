//
//  NewMessageViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 27/12/23.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

@MainActor
class NewMessageViewModel: ObservableObject {
    
    @Published var users = [User]()
    @Published var searchUser = ""
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $searchUser
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] _ in
                Task {
                    do {
                        try await self?.fetchUsers()
                    } catch {
                        print("Error fetching users: \(error)")
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchUsers() async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let fetchedUsers = try await UserService.fetchAllUsers()
        DispatchQueue.main.async {
            self.users = fetchedUsers.filter { $0.id != currentUid }
        }
    }
    
    // Computed property to get filtered users
    var filteredUsers: [User] {
        guard !searchUser.isEmpty else {
            return users
        }
        
        return users.filter { user in
            return user.fullName?
                .localizedCaseInsensitiveContains(searchUser) ?? false
        }
    }
}
